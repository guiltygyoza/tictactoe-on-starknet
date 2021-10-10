%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.storage import Storage
from starkware.cairo.common.math import (
    unsigned_div_rem, assert_nn_le)
from starkware.cairo.common.math_cmp import (
    is_not_zero, is_le)

func is_zero {range_check_ptr} (value) -> (res):
    # invert the result of is_not_zero()
    let (temp) = is_not_zero(value)
    if temp == 0:
        return (res=1)
    end

    return (res=0)
end

@storage_var
func board (
        x : felt,
        y : felt
    ) -> (
        z : felt
    ):
    # x: 0, 1, 2
    # y: 0, 1, 2
    # z: 0 (empty), 1 (O), 2 (X); 0 by default automatically
end

@view
func view_board {
        storage_ptr : Storage*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (
        b_0_0 : felt,
        b_0_1 : felt,
        b_0_2 : felt,
        b_1_0 : felt,
        b_1_1 : felt,
        b_1_2 : felt,
        b_2_0 : felt,
        b_2_1 : felt,
        b_2_2 : felt
    ):

    let (b_0_0) = board.read(0,0)
    let (b_0_1) = board.read(0,1)
    let (b_0_2) = board.read(0,2)
    let (b_1_0) = board.read(1,0)
    let (b_1_1) = board.read(1,1)
    let (b_1_2) = board.read(1,2)
    let (b_2_0) = board.read(2,0)
    let (b_2_1) = board.read(2,1)
    let (b_2_2) = board.read(2,2)

    return (
        b_0_0, b_1_0, b_2_0,
        b_0_1, b_1_1, b_2_1,
        b_0_2, b_1_2, b_2_2
    )
end

@external
func test_configure_board {
        storage_ptr : Storage*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        x : felt,
        y : felt,
        b : felt
    ) -> ():
    assert_nn_le(b,2) # b should be in [0,1,2]
    board.write(x,y,b)
    return ()
end

@external
func reset_board {
        storage_ptr : Storage*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> ():
    board.write(0,0,0)
    board.write(0,1,0)
    board.write(0,2,0)
    board.write(1,0,0)
    board.write(1,1,0)
    board.write(1,2,0)
    board.write(2,0,0)
    board.write(2,1,0)
    board.write(2,2,0)
    return ()
end


@external
func user_move {
        storage_ptr : Storage*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        x : felt,
        y : felt
    ) -> (
        q_a_0 : felt,
        q_a_1 : felt,
        q_a_2 : felt,
        q_a_3 : felt,
        q_a_4 : felt,
        q_a_5 : felt,
        q_a_6 : felt,
        q_a_7 : felt,
        q_a_8 : felt,
        q_max : felt,
        argmax : felt,
        x_ai : felt,
        y_ai : felt
    ):
    alloc_locals

    # Algorithm
    # =============================================
    # 1. assert user-chosen location is empty
    # 2. update board with user move (user is O==1)
    # 3. encode current board into s : felt
    # 4. compute AI's encoded action a = argmax_a ( q_lookup(a,s) )
    # 5. decode AI's encoded action into AI move
    # 6. update board with AI move (AI is X==2)
    # 7. return AI move
    # =============================================

    # 1. assert user-chosen location is empty
    let (user_move_cell) = board.read(x,y)
    assert user_move_cell = 0

    # 2. update board with user move (user is 2)
    board.write(x,y,2)
    let (user_move_cell_done) = board.read(x,y)
    assert user_move_cell_done = 2

    # 3. encode current board into s - using base-3 (ternary) representation
    #    further multiplied by 10 to have s domain's minimum distance >
    #    a domain's maximum distance
    let (local b_0_0) = board.read(0,0)
    let (local b_0_1) = board.read(0,1)
    let (local b_0_2) = board.read(0,2)
    let (local b_1_0) = board.read(1,0)
    let (local b_1_1) = board.read(1,1)
    let (local b_1_2) = board.read(1,2)
    let (local b_2_0) = board.read(2,0)
    let (local b_2_1) = board.read(2,1)
    let (local b_2_2) = board.read(2,2)
    tempvar s_0 = b_0_0 + 3 * b_0_1 + 9 * b_0_2
    tempvar s_1 = (b_1_0 + 3 * b_1_1 + 9 * b_1_2) * 27
    tempvar s_2 = (b_2_0 + 3 * b_2_1 + 9 * b_2_2) * 729
    local s = (s_0 + s_1 + s_2) * 10

    # 4. compute AI's encoded action a = argmax_a ( q_lookup(a,s) )
    let (local q_a_0) = q_lookup(a=0, s=s)
    let (local q_a_1) = q_lookup(a=1, s=s)
    let (local q_a_2) = q_lookup(a=2, s=s)
    let (local q_a_3) = q_lookup(a=3, s=s)
    let (local q_a_4) = q_lookup(a=4, s=s)
    let (local q_a_5) = q_lookup(a=5, s=s)
    let (local q_a_6) = q_lookup(a=6, s=s)
    let (local q_a_7) = q_lookup(a=7, s=s)
    let (local q_a_8) = q_lookup(a=8, s=s)

    # Store storage_ptr and pedersen_ptr; otherwise revoked by is_le operations below
    local storage_ptr : Storage* = storage_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr

    # O(N) finding a valid argmax
    local q_max_ini = 0
    local argmax_ini = 9 # start with invalid move

    let (local bool_le_0) = is_le(q_max_ini, q_a_0)
    let (local bool_valid_0) = is_zero(b_0_0)
    local bool_better_0 = bool_le_0 * bool_valid_0
    local q_max_0 = bool_better_0 * q_a_0 + (1-bool_better_0) * q_max_ini
    local argmax_0 = bool_better_0 * 0 + (1-bool_better_0) * argmax_ini

    let (local bool_le_1) = is_le(q_max_0, q_a_1)
    let (local bool_valid_1) = is_zero(b_0_1)
    local bool_better_1 = bool_le_1 * bool_valid_1
    local q_max_1 = bool_better_1 * q_a_1 + (1-bool_better_1) * q_max_0
    local argmax_1 = bool_better_1 * 1 + (1-bool_better_1) * argmax_0

    let (local bool_le_2) = is_le(q_max_1, q_a_2)
    let (local bool_valid_2) = is_zero(b_0_2)
    local bool_better_2 = bool_le_2 * bool_valid_2
    local q_max_2 = bool_better_2 * q_a_2 + (1-bool_better_2) * q_max_1
    local argmax_2 = bool_better_2 * 2 + (1-bool_better_2) * argmax_1

    let (local bool_le_3) = is_le(q_max_2, q_a_3)
    let (local bool_valid_3) = is_zero(b_1_0)
    local bool_better_3 = bool_le_3 * bool_valid_3
    local q_max_3 = bool_better_3 * q_a_3 + (1-bool_better_3) * q_max_2
    local argmax_3 = bool_better_3 * 3 + (1-bool_better_3) * argmax_2

    let (local bool_le_4) = is_le(q_max_3, q_a_4)
    let (local bool_valid_4) = is_zero(b_1_1)
    local bool_better_4 = bool_le_4 * bool_valid_4
    local q_max_4 = bool_better_4 * q_a_4 + (1-bool_better_4) * q_max_3
    local argmax_4 = bool_better_4 * 4 + (1-bool_better_4) * argmax_3

    let (local bool_le_5) = is_le(q_max_4, q_a_5)
    let (local bool_valid_5) = is_zero(b_1_2)
    local bool_better_5 = bool_le_5 * bool_valid_5
    local q_max_5 = bool_better_5 * q_a_5 + (1-bool_better_5) * q_max_4
    local argmax_5 = bool_better_5 * 5 + (1-bool_better_5) * argmax_4

    let (local bool_le_6) = is_le(q_max_5, q_a_6)
    let (local bool_valid_6) = is_zero(b_2_0)
    local bool_better_6 = bool_le_6 * bool_valid_6
    local q_max_6 = bool_better_6 * q_a_6 + (1-bool_better_6) * q_max_5
    local argmax_6 = bool_better_6 * 6 + (1-bool_better_6) * argmax_5

    let (local bool_le_7) = is_le(q_max_6, q_a_7)
    let (local bool_valid_7) = is_zero(b_2_1)
    local bool_better_7 = bool_le_7 * bool_valid_7
    local q_max_7 = bool_better_7 * q_a_7 + (1-bool_better_7) * q_max_6
    local argmax_7 = bool_better_7 * 7 + (1-bool_better_7) * argmax_6

    let (local bool_le_8) = is_le(q_max_7, q_a_8)
    let (local bool_valid_8) = is_zero(b_2_2)
    local bool_better_8 = bool_le_8 * bool_valid_8
    local q_max_8 = bool_better_8 * q_a_8 + (1-bool_better_8) * q_max_7
    local argmax_8 = bool_better_8 * 8 + (1-bool_better_8) * argmax_7

    local q_max = q_max_8
    local argmax = argmax_8

    # 5. decode AI's encoded action into AI move
    let (x_ai, y_ai) = unsigned_div_rem (argmax, 3)
    # TODO: handles the case where AI doesn't know how to move and still should make valid move

    # 6. update board with AI move (AI is 1)
    let (ai_move_cell) = board.read(x_ai, y_ai)
    #assert ai_move_cell = 0
    #board.write(x_ai, y_ai, 1)
    #let (ai_move_cell_done) = board.read(x_ai, y_ai)
    #assert ai_move_cell_done = 1

    # 7. return AI move
    return (q_a_0, q_a_1, q_a_2, q_a_3, q_a_4, q_a_5, q_a_6, q_a_7, q_a_8, q_max, argmax, x_ai, y_ai)
end

@view
func toy_lookup {
        storage_ptr : Storage*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        x : felt,
        y : felt
    ) -> (
        z : felt
    ):

    let (bool_x_0) = is_zero(x-10)
    let (bool_x_1) = is_zero(x-20)
    let (bool_y_0) = is_zero(y-50)
    let (bool_y_1) = is_zero(y-100)
    tempvar col_0 = bool_x_0 * bool_y_0 * 1 + bool_x_0 * bool_y_1 * 3
    tempvar col_1 = bool_x_1 * bool_y_0 * 2 + bool_x_1 * bool_y_1 * 4
    tempvar z = col_0 + col_1

    return (z)
end

#######################################
####### GENERATED PROGRAM BELOW #######
#######################################

func q_lookup {
        storage_ptr : Storage*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        a : felt,
        s : felt
    ) -> (
        q : felt
    ):
    alloc_locals

    let (local bool_a_0) = is_zero(a-0)
    let (local bool_a_1) = is_zero(a-1)
    let (local bool_a_2) = is_zero(a-2)
    let (local bool_a_3) = is_zero(a-3)
    let (local bool_a_4) = is_zero(a-4)
    let (local bool_a_5) = is_zero(a-5)
    let (local bool_a_6) = is_zero(a-6)
    let (local bool_a_7) = is_zero(a-7)
    let (local bool_a_8) = is_zero(a-8)

    let (local bool_s_1950) = is_zero(s-1950)
    let (local bool_s_64290) = is_zero(s-64290)
    let (local bool_s_52740) = is_zero(s-52740)
    let (local bool_s_26510) = is_zero(s-26510)
    let (local bool_s_72180) = is_zero(s-72180)
    let (local bool_s_45500) = is_zero(s-45500)
    let (local bool_s_11360) = is_zero(s-11360)
    let (local bool_s_183880) = is_zero(s-183880)
    let (local bool_s_11940) = is_zero(s-11940)
    let (local bool_s_30980) = is_zero(s-30980)
    let (local bool_s_16630) = is_zero(s-16630)
    let (local bool_s_11270) = is_zero(s-11270)
    let (local bool_s_4120) = is_zero(s-4120)
    let (local bool_s_118830) = is_zero(s-118830)
    let (local bool_s_3840) = is_zero(s-3840)
    let (local bool_s_53410) = is_zero(s-53410)
    let (local bool_s_116240) = is_zero(s-116240)
    let (local bool_s_157470) = is_zero(s-157470)
    let (local bool_s_142490) = is_zero(s-142490)
    let (local bool_s_144010) = is_zero(s-144010)
    let (local bool_s_37280) = is_zero(s-37280)
    let (local bool_s_135600) = is_zero(s-135600)
    let (local bool_s_67420) = is_zero(s-67420)
    let (local bool_s_38400) = is_zero(s-38400)
    let (local bool_s_74580) = is_zero(s-74580)
    let (local bool_s_67680) = is_zero(s-67680)
    let (local bool_s_155370) = is_zero(s-155370)
    let (local bool_s_36510) = is_zero(s-36510)
    let (local bool_s_18720) = is_zero(s-18720)
    let (local bool_s_8970) = is_zero(s-8970)
    let (local bool_s_157290) = is_zero(s-157290)
    let (local bool_s_4300) = is_zero(s-4300)
    let (local bool_s_79590) = is_zero(s-79590)
    let (local bool_s_4050) = is_zero(s-4050)
    let (local bool_s_65170) = is_zero(s-65170)
    let (local bool_s_2630) = is_zero(s-2630)
    let (local bool_s_87080) = is_zero(s-87080)
    let (local bool_s_2970) = is_zero(s-2970)
    let (local bool_s_14220) = is_zero(s-14220)
    let (local bool_s_103700) = is_zero(s-103700)
    let (local bool_s_2190) = is_zero(s-2190)
    let (local bool_s_16840) = is_zero(s-16840)
    let (local bool_s_51210) = is_zero(s-51210)
    let (local bool_s_135840) = is_zero(s-135840)
    let (local bool_s_117650) = is_zero(s-117650)
    let (local bool_s_146830) = is_zero(s-146830)
    let (local bool_s_173500) = is_zero(s-173500)
    let (local bool_s_69740) = is_zero(s-69740)
    let (local bool_s_14740) = is_zero(s-14740)
    let (local bool_s_51030) = is_zero(s-51030)
    let (local bool_s_2070) = is_zero(s-2070)
    let (local bool_s_87030) = is_zero(s-87030)
    let (local bool_s_43830) = is_zero(s-43830)
    let (local bool_s_131220) = is_zero(s-131220)
    let (local bool_s_183970) = is_zero(s-183970)
    let (local bool_s_132930) = is_zero(s-132930)
    let (local bool_s_2000) = is_zero(s-2000)
    let (local bool_s_38220) = is_zero(s-38220)
    let (local bool_s_5310) = is_zero(s-5310)
    let (local bool_s_69840) = is_zero(s-69840)
    let (local bool_s_9540) = is_zero(s-9540)
    let (local bool_s_118440) = is_zero(s-118440)
    let (local bool_s_5690) = is_zero(s-5690)
    let (local bool_s_2170) = is_zero(s-2170)
    let (local bool_s_129710) = is_zero(s-129710)
    let (local bool_s_38340) = is_zero(s-38340)
    let (local bool_s_0) = is_zero(s-0)
    let (local bool_s_108080) = is_zero(s-108080)
    let (local bool_s_82250) = is_zero(s-82250)
    let (local bool_s_16290) = is_zero(s-16290)
    let (local bool_s_39080) = is_zero(s-39080)
    let (local bool_s_21340) = is_zero(s-21340)
    let (local bool_s_71820) = is_zero(s-71820)
    let (local bool_s_4260) = is_zero(s-4260)
    let (local bool_s_13990) = is_zero(s-13990)
    let (local bool_s_169930) = is_zero(s-169930)
    let (local bool_s_42560) = is_zero(s-42560)
    let (local bool_s_123260) = is_zero(s-123260)
    let (local bool_s_140340) = is_zero(s-140340)
    let (local bool_s_23560) = is_zero(s-23560)
    let (local bool_s_1770) = is_zero(s-1770)
    let (local bool_s_16610) = is_zero(s-16610)
    let (local bool_s_2120) = is_zero(s-2120)
    let (local bool_s_45120) = is_zero(s-45120)
    let (local bool_s_16470) = is_zero(s-16470)
    let (local bool_s_67410) = is_zero(s-67410)
    let (local bool_s_43210) = is_zero(s-43210)
    let (local bool_s_143190) = is_zero(s-143190)
    let (local bool_s_43290) = is_zero(s-43290)
    let (local bool_s_43360) = is_zero(s-43360)
    let (local bool_s_86950) = is_zero(s-86950)
    let (local bool_s_1890) = is_zero(s-1890)
    let (local bool_s_123500) = is_zero(s-123500)
    let (local bool_s_137800) = is_zero(s-137800)
    let (local bool_s_113630) = is_zero(s-113630)
    let (local bool_s_210) = is_zero(s-210)
    let (local bool_s_1670) = is_zero(s-1670)
    let (local bool_s_46800) = is_zero(s-46800)
    let (local bool_s_45580) = is_zero(s-45580)
    let (local bool_s_125590) = is_zero(s-125590)
    let (local bool_s_180) = is_zero(s-180)
    let (local bool_s_12150) = is_zero(s-12150)
    let (local bool_s_92270) = is_zero(s-92270)
    let (local bool_s_169870) = is_zero(s-169870)
    let (local bool_s_117180) = is_zero(s-117180)
    let (local bool_s_140770) = is_zero(s-140770)
    let (local bool_s_87050) = is_zero(s-87050)
    let (local bool_s_55290) = is_zero(s-55290)
    let (local bool_s_55840) = is_zero(s-55840)
    let (local bool_s_147790) = is_zero(s-147790)
    let (local bool_s_143110) = is_zero(s-143110)
    let (local bool_s_70390) = is_zero(s-70390)
    let (local bool_s_6800) = is_zero(s-6800)
    let (local bool_s_135050) = is_zero(s-135050)
    let (local bool_s_138840) = is_zero(s-138840)
    let (local bool_s_11580) = is_zero(s-11580)
    let (local bool_s_6760) = is_zero(s-6760)
    let (local bool_s_74540) = is_zero(s-74540)
    let (local bool_s_153920) = is_zero(s-153920)
    let (local bool_s_92150) = is_zero(s-92150)
    let (local bool_s_47540) = is_zero(s-47540)
    let (local bool_s_118470) = is_zero(s-118470)
    let (local bool_s_113150) = is_zero(s-113150)
    let (local bool_s_71300) = is_zero(s-71300)
    let (local bool_s_9090) = is_zero(s-9090)
    let (local bool_s_67280) = is_zero(s-67280)
    let (local bool_s_183820) = is_zero(s-183820)
    let (local bool_s_155580) = is_zero(s-155580)
    let (local bool_s_31320) = is_zero(s-31320)
    let (local bool_s_118890) = is_zero(s-118890)
    let (local bool_s_8020) = is_zero(s-8020)
    let (local bool_s_2100) = is_zero(s-2100)
    let (local bool_s_85970) = is_zero(s-85970)
    let (local bool_s_11400) = is_zero(s-11400)
    let (local bool_s_72360) = is_zero(s-72360)
    let (local bool_s_9670) = is_zero(s-9670)
    let (local bool_s_169300) = is_zero(s-169300)
    let (local bool_s_11520) = is_zero(s-11520)
    let (local bool_s_103970) = is_zero(s-103970)
    let (local bool_s_133200) = is_zero(s-133200)
    let (local bool_s_150210) = is_zero(s-150210)
    let (local bool_s_77670) = is_zero(s-77670)
    let (local bool_s_9480) = is_zero(s-9480)
    let (local bool_s_129740) = is_zero(s-129740)
    let (local bool_s_61670) = is_zero(s-61670)
    let (local bool_s_87100) = is_zero(s-87100)
    let (local bool_s_16480) = is_zero(s-16480)
    let (local bool_s_20540) = is_zero(s-20540)
    let (local bool_s_45820) = is_zero(s-45820)
    let (local bool_s_1810) = is_zero(s-1810)
    let (local bool_s_105210) = is_zero(s-105210)
    let (local bool_s_134350) = is_zero(s-134350)
    let (local bool_s_72280) = is_zero(s-72280)
    let (local bool_s_52310) = is_zero(s-52310)
    let (local bool_s_20340) = is_zero(s-20340)
    let (local bool_s_165160) = is_zero(s-165160)
    let (local bool_s_182260) = is_zero(s-182260)
    let (local bool_s_24180) = is_zero(s-24180)
    let (local bool_s_135820) = is_zero(s-135820)
    let (local bool_s_111190) = is_zero(s-111190)
    let (local bool_s_157140) = is_zero(s-157140)
    let (local bool_s_74720) = is_zero(s-74720)
    let (local bool_s_161390) = is_zero(s-161390)
    let (local bool_s_131330) = is_zero(s-131330)
    let (local bool_s_7760) = is_zero(s-7760)
    let (local bool_s_171810) = is_zero(s-171810)
    let (local bool_s_43310) = is_zero(s-43310)
    let (local bool_s_125870) = is_zero(s-125870)
    let (local bool_s_81920) = is_zero(s-81920)
    let (local bool_s_67230) = is_zero(s-67230)
    let (local bool_s_1010) = is_zero(s-1010)
    let (local bool_s_140290) = is_zero(s-140290)
    let (local bool_s_133800) = is_zero(s-133800)
    let (local bool_s_51580) = is_zero(s-51580)
    let (local bool_s_19870) = is_zero(s-19870)
    let (local bool_s_68760) = is_zero(s-68760)
    let (local bool_s_116210) = is_zero(s-116210)
    let (local bool_s_154780) = is_zero(s-154780)
    let (local bool_s_74690) = is_zero(s-74690)
    let (local bool_s_166870) = is_zero(s-166870)
    let (local bool_s_3320) = is_zero(s-3320)
    let (local bool_s_31510) = is_zero(s-31510)
    let (local bool_s_131230) = is_zero(s-131230)
    let (local bool_s_4230) = is_zero(s-4230)
    let (local bool_s_151570) = is_zero(s-151570)
    let (local bool_s_116100) = is_zero(s-116100)
    let (local bool_s_38230) = is_zero(s-38230)
    let (local bool_s_157200) = is_zero(s-157200)
    let (local bool_s_50520) = is_zero(s-50520)
    let (local bool_s_4400) = is_zero(s-4400)
    let (local bool_s_171880) = is_zero(s-171880)
    let (local bool_s_23490) = is_zero(s-23490)
    let (local bool_s_11570) = is_zero(s-11570)
    let (local bool_s_1050) = is_zero(s-1050)
    let (local bool_s_138070) = is_zero(s-138070)
    let (local bool_s_162550) = is_zero(s-162550)
    let (local bool_s_121500) = is_zero(s-121500)
    let (local bool_s_149190) = is_zero(s-149190)
    let (local bool_s_13430) = is_zero(s-13430)
    let (local bool_s_760) = is_zero(s-760)
    let (local bool_s_103740) = is_zero(s-103740)
    let (local bool_s_890) = is_zero(s-890)
    let (local bool_s_139790) = is_zero(s-139790)
    let (local bool_s_135360) = is_zero(s-135360)
    let (local bool_s_70380) = is_zero(s-70380)
    let (local bool_s_162610) = is_zero(s-162610)
    let (local bool_s_5960) = is_zero(s-5960)
    let (local bool_s_134280) = is_zero(s-134280)
    let (local bool_s_6490) = is_zero(s-6490)
    let (local bool_s_82100) = is_zero(s-82100)
    let (local bool_s_151900) = is_zero(s-151900)
    let (local bool_s_72410) = is_zero(s-72410)
    let (local bool_s_171790) = is_zero(s-171790)
    let (local bool_s_38140) = is_zero(s-38140)
    let (local bool_s_55270) = is_zero(s-55270)
    let (local bool_s_103750) = is_zero(s-103750)
    let (local bool_s_14800) = is_zero(s-14800)
    let (local bool_s_4600) = is_zero(s-4600)
    let (local bool_s_21490) = is_zero(s-21490)
    let (local bool_s_79530) = is_zero(s-79530)
    let (local bool_s_4860) = is_zero(s-4860)
    let (local bool_s_113850) = is_zero(s-113850)
    let (local bool_s_43090) = is_zero(s-43090)
    let (local bool_s_870) = is_zero(s-870)
    let (local bool_s_60220) = is_zero(s-60220)
    let (local bool_s_169570) = is_zero(s-169570)
    let (local bool_s_8840) = is_zero(s-8840)
    let (local bool_s_186490) = is_zero(s-186490)
    let (local bool_s_13910) = is_zero(s-13910)
    let (local bool_s_57730) = is_zero(s-57730)
    let (local bool_s_108700) = is_zero(s-108700)
    let (local bool_s_7900) = is_zero(s-7900)
    let (local bool_s_109350) = is_zero(s-109350)
    let (local bool_s_160440) = is_zero(s-160440)
    let (local bool_s_12070) = is_zero(s-12070)
    let (local bool_s_28360) = is_zero(s-28360)
    let (local bool_s_86990) = is_zero(s-86990)
    let (local bool_s_9640) = is_zero(s-9640)
    let (local bool_s_37430) = is_zero(s-37430)
    let (local bool_s_150010) = is_zero(s-150010)
    let (local bool_s_104120) = is_zero(s-104120)
    let (local bool_s_6510) = is_zero(s-6510)
    let (local bool_s_143260) = is_zero(s-143260)
    let (local bool_s_7830) = is_zero(s-7830)
    let (local bool_s_80190) = is_zero(s-80190)
    let (local bool_s_48000) = is_zero(s-48000)
    let (local bool_s_44840) = is_zero(s-44840)
    let (local bool_s_160000) = is_zero(s-160000)
    let (local bool_s_55040) = is_zero(s-55040)
    let (local bool_s_71100) = is_zero(s-71100)
    let (local bool_s_62130) = is_zero(s-62130)
    let (local bool_s_13140) = is_zero(s-13140)
    let (local bool_s_830) = is_zero(s-830)
    let (local bool_s_118490) = is_zero(s-118490)
    let (local bool_s_53150) = is_zero(s-53150)
    let (local bool_s_4590) = is_zero(s-4590)
    let (local bool_s_86830) = is_zero(s-86830)
    let (local bool_s_169450) = is_zero(s-169450)
    let (local bool_s_47520) = is_zero(s-47520)
    let (local bool_s_111260) = is_zero(s-111260)
    let (local bool_s_135900) = is_zero(s-135900)
    let (local bool_s_157690) = is_zero(s-157690)
    let (local bool_s_149940) = is_zero(s-149940)
    let (local bool_s_110970) = is_zero(s-110970)
    let (local bool_s_67800) = is_zero(s-67800)
    let (local bool_s_1760) = is_zero(s-1760)
    let (local bool_s_24190) = is_zero(s-24190)
    let (local bool_s_118810) = is_zero(s-118810)
    let (local bool_s_43750) = is_zero(s-43750)
    let (local bool_s_4870) = is_zero(s-4870)
    let (local bool_s_124760) = is_zero(s-124760)
    let (local bool_s_70130) = is_zero(s-70130)
    let (local bool_s_165040) = is_zero(s-165040)
    let (local bool_s_38510) = is_zero(s-38510)
    let (local bool_s_9410) = is_zero(s-9410)
    let (local bool_s_162060) = is_zero(s-162060)
    let (local bool_s_24120) = is_zero(s-24120)
    let (local bool_s_85880) = is_zero(s-85880)
    let (local bool_s_46280) = is_zero(s-46280)
    let (local bool_s_66980) = is_zero(s-66980)
    let (local bool_s_26690) = is_zero(s-26690)
    let (local bool_s_57610) = is_zero(s-57610)
    let (local bool_s_147250) = is_zero(s-147250)
    let (local bool_s_38770) = is_zero(s-38770)
    let (local bool_s_72590) = is_zero(s-72590)
    let (local bool_s_38100) = is_zero(s-38100)
    let (local bool_s_162150) = is_zero(s-162150)
    let (local bool_s_46170) = is_zero(s-46170)
    let (local bool_s_7350) = is_zero(s-7350)
    let (local bool_s_145150) = is_zero(s-145150)
    let (local bool_s_135070) = is_zero(s-135070)
    let (local bool_s_130800) = is_zero(s-130800)
    let (local bool_s_125240) = is_zero(s-125240)
    let (local bool_s_43740) = is_zero(s-43740)
    let (local bool_s_137980) = is_zero(s-137980)
    let (local bool_s_86330) = is_zero(s-86330)
    let (local bool_s_120890) = is_zero(s-120890)
    let (local bool_s_3800) = is_zero(s-3800)
    let (local bool_s_72200) = is_zero(s-72200)
    let (local bool_s_113900) = is_zero(s-113900)
    let (local bool_s_8930) = is_zero(s-8930)
    let (local bool_s_51320) = is_zero(s-51320)
    let (local bool_s_15390) = is_zero(s-15390)
    let (local bool_s_157770) = is_zero(s-157770)
    let (local bool_s_118310) = is_zero(s-118310)
    let (local bool_s_84310) = is_zero(s-84310)
    let (local bool_s_74750) = is_zero(s-74750)
    let (local bool_s_1620) = is_zero(s-1620)
    let (local bool_s_69860) = is_zero(s-69860)
    let (local bool_s_16230) = is_zero(s-16230)
    let (local bool_s_138510) = is_zero(s-138510)
    let (local bool_s_24040) = is_zero(s-24040)
    let (local bool_s_45390) = is_zero(s-45390)
    let (local bool_s_172140) = is_zero(s-172140)
    let (local bool_s_28420) = is_zero(s-28420)
    let (local bool_s_125090) = is_zero(s-125090)
    let (local bool_s_157830) = is_zero(s-157830)
    let (local bool_s_132850) = is_zero(s-132850)
    let (local bool_s_135490) = is_zero(s-135490)
    let (local bool_s_81950) = is_zero(s-81950)
    let (local bool_s_65670) = is_zero(s-65670)
    let (local bool_s_30960) = is_zero(s-30960)
    let (local bool_s_14060) = is_zero(s-14060)
    let (local bool_s_121420) = is_zero(s-121420)
    let (local bool_s_118850) = is_zero(s-118850)
    let (local bool_s_155260) = is_zero(s-155260)
    let (local bool_s_65790) = is_zero(s-65790)
    let (local bool_s_24250) = is_zero(s-24250)
    let (local bool_s_108870) = is_zero(s-108870)
    let (local bool_s_121790) = is_zero(s-121790)
    let (local bool_s_66500) = is_zero(s-66500)
    let (local bool_s_133180) = is_zero(s-133180)
    let (local bool_s_160730) = is_zero(s-160730)
    let (local bool_s_23510) = is_zero(s-23510)
    let (local bool_s_118370) = is_zero(s-118370)
    let (local bool_s_28510) = is_zero(s-28510)
    let (local bool_s_116660) = is_zero(s-116660)
    let (local bool_s_184230) = is_zero(s-184230)
    let (local bool_s_38180) = is_zero(s-38180)
    let (local bool_s_154720) = is_zero(s-154720)
    let (local bool_s_111240) = is_zero(s-111240)
    let (local bool_s_48960) = is_zero(s-48960)
    let (local bool_s_30800) = is_zero(s-30800)
    let (local bool_s_116150) = is_zero(s-116150)
    let (local bool_s_43340) = is_zero(s-43340)
    let (local bool_s_169630) = is_zero(s-169630)
    let (local bool_s_111060) = is_zero(s-111060)
    let (local bool_s_108920) = is_zero(s-108920)
    let (local bool_s_23600) = is_zero(s-23600)
    let (local bool_s_4340) = is_zero(s-4340)
    let (local bool_s_31470) = is_zero(s-31470)
    let (local bool_s_147700) = is_zero(s-147700)
    let (local bool_s_1710) = is_zero(s-1710)
    let (local bool_s_110) = is_zero(s-110)
    let (local bool_s_23550) = is_zero(s-23550)
    let (local bool_s_1940) = is_zero(s-1940)
    let (local bool_s_40500) = is_zero(s-40500)
    let (local bool_s_38490) = is_zero(s-38490)
    let (local bool_s_38120) = is_zero(s-38120)
    let (local bool_s_28350) = is_zero(s-28350)
    let (local bool_s_15500) = is_zero(s-15500)
    let (local bool_s_138800) = is_zero(s-138800)
    let (local bool_s_154900) = is_zero(s-154900)
    let (local bool_s_81970) = is_zero(s-81970)
    let (local bool_s_14670) = is_zero(s-14670)
    let (local bool_s_55310) = is_zero(s-55310)
    let (local bool_s_80380) = is_zero(s-80380)
    let (local bool_s_133820) = is_zero(s-133820)
    let (local bool_s_59450) = is_zero(s-59450)
    let (local bool_s_81840) = is_zero(s-81840)
    let (local bool_s_1630) = is_zero(s-1630)
    let (local bool_s_67730) = is_zero(s-67730)
    let (local bool_s_52860) = is_zero(s-52860)
    let (local bool_s_15440) = is_zero(s-15440)
    let (local bool_s_20) = is_zero(s-20)
    let (local bool_s_14150) = is_zero(s-14150)
    let (local bool_s_162190) = is_zero(s-162190)
    let (local bool_s_4660) = is_zero(s-4660)
    let (local bool_s_55580) = is_zero(s-55580)
    let (local bool_s_161270) = is_zero(s-161270)
    let (local bool_s_176680) = is_zero(s-176680)
    let (local bool_s_16360) = is_zero(s-16360)
    let (local bool_s_54070) = is_zero(s-54070)
    let (local bool_s_52070) = is_zero(s-52070)
    let (local bool_s_22760) = is_zero(s-22760)
    let (local bool_s_9460) = is_zero(s-9460)
    let (local bool_s_115970) = is_zero(s-115970)
    let (local bool_s_60300) = is_zero(s-60300)
    let (local bool_s_162700) = is_zero(s-162700)
    let (local bool_s_132880) = is_zero(s-132880)
    let (local bool_s_38070) = is_zero(s-38070)
    let (local bool_s_72380) = is_zero(s-72380)
    let (local bool_s_67520) = is_zero(s-67520)
    let (local bool_s_67700) = is_zero(s-67700)
    let (local bool_s_110980) = is_zero(s-110980)
    let (local bool_s_45370) = is_zero(s-45370)
    let (local bool_s_140050) = is_zero(s-140050)
    let (local bool_s_152650) = is_zero(s-152650)
    let (local bool_s_81860) = is_zero(s-81860)
    let (local bool_s_540) = is_zero(s-540)
    let (local bool_s_4800) = is_zero(s-4800)
    let (local bool_s_154800) = is_zero(s-154800)
    let (local bool_s_12030) = is_zero(s-12030)
    let (local bool_s_81820) = is_zero(s-81820)
    let (local bool_s_157680) = is_zero(s-157680)
    let (local bool_s_183990) = is_zero(s-183990)
    let (local bool_s_47980) = is_zero(s-47980)
    let (local bool_s_94130) = is_zero(s-94130)
    let (local bool_s_70410) = is_zero(s-70410)
    let (local bool_s_31530) = is_zero(s-31530)
    let (local bool_s_14870) = is_zero(s-14870)
    let (local bool_s_133300) = is_zero(s-133300)
    let (local bool_s_36450) = is_zero(s-36450)
    let (local bool_s_116110) = is_zero(s-116110)
    let (local bool_s_60040) = is_zero(s-60040)
    let (local bool_s_67250) = is_zero(s-67250)
    let (local bool_s_64400) = is_zero(s-64400)
    let (local bool_s_135970) = is_zero(s-135970)
    let (local bool_s_6840) = is_zero(s-6840)
    let (local bool_s_630) = is_zero(s-630)
    let (local bool_s_171520) = is_zero(s-171520)
    let (local bool_s_171730) = is_zero(s-171730)
    let (local bool_s_129980) = is_zero(s-129980)
    let (local bool_s_4950) = is_zero(s-4950)
    let (local bool_s_16340) = is_zero(s-16340)
    let (local bool_s_159580) = is_zero(s-159580)
    let (local bool_s_72230) = is_zero(s-72230)
    let (local bool_s_176620) = is_zero(s-176620)
    let (local bool_s_67460) = is_zero(s-67460)
    let (local bool_s_14590) = is_zero(s-14590)
    let (local bool_s_21420) = is_zero(s-21420)
    let (local bool_s_70580) = is_zero(s-70580)
    let (local bool_s_55370) = is_zero(s-55370)
    let (local bool_s_21930) = is_zero(s-21930)
    let (local bool_s_89690) = is_zero(s-89690)
    let (local bool_s_116190) = is_zero(s-116190)
    let (local bool_s_8300) = is_zero(s-8300)
    let (local bool_s_23540) = is_zero(s-23540)
    let (local bool_s_110180) = is_zero(s-110180)
    let (local bool_s_72090) = is_zero(s-72090)
    let (local bool_s_111020) = is_zero(s-111020)
    let (local bool_s_179100) = is_zero(s-179100)
    let (local bool_s_67300) = is_zero(s-67300)
    let (local bool_s_41200) = is_zero(s-41200)
    let (local bool_s_140830) = is_zero(s-140830)
    let (local bool_s_4160) = is_zero(s-4160)
    let (local bool_s_1780) = is_zero(s-1780)
    let (local bool_s_133110) = is_zero(s-133110)
    let (local bool_s_118760) = is_zero(s-118760)
    let (local bool_s_85140) = is_zero(s-85140)
    let (local bool_s_124850) = is_zero(s-124850)
    let (local bool_s_140130) = is_zero(s-140130)
    let (local bool_s_12060) = is_zero(s-12060)
    let (local bool_s_109980) = is_zero(s-109980)
    let (local bool_s_94310) = is_zero(s-94310)
    let (local bool_s_184450) = is_zero(s-184450)
    let (local bool_s_177480) = is_zero(s-177480)
    let (local bool_s_135540) = is_zero(s-135540)
    let (local bool_s_4070) = is_zero(s-4070)
    let (local bool_s_4810) = is_zero(s-4810)
    let (local bool_s_173680) = is_zero(s-173680)
    let (local bool_s_67770) = is_zero(s-67770)
    let (local bool_s_70620) = is_zero(s-70620)
    let (local bool_s_84260) = is_zero(s-84260)
    let (local bool_s_12700) = is_zero(s-12700)
    let (local bool_s_45770) = is_zero(s-45770)
    let (local bool_s_7640) = is_zero(s-7640)
    let (local bool_s_81960) = is_zero(s-81960)
    let (local bool_s_59220) = is_zero(s-59220)
    let (local bool_s_86300) = is_zero(s-86300)
    let (local bool_s_7890) = is_zero(s-7890)
    let (local bool_s_157840) = is_zero(s-157840)
    let (local bool_s_680) = is_zero(s-680)
    let (local bool_s_16300) = is_zero(s-16300)
    let (local bool_s_48010) = is_zero(s-48010)
    let (local bool_s_57630) = is_zero(s-57630)
    let (local bool_s_1910) = is_zero(s-1910)
    let (local bool_s_149210) = is_zero(s-149210)
    let (local bool_s_108650) = is_zero(s-108650)
    let (local bool_s_113400) = is_zero(s-113400)
    let (local bool_s_140200) = is_zero(s-140200)
    let (local bool_s_6750) = is_zero(s-6750)
    let (local bool_s_125580) = is_zero(s-125580)
    let (local bool_s_118550) = is_zero(s-118550)
    let (local bool_s_67440) = is_zero(s-67440)
    let (local bool_s_164610) = is_zero(s-164610)
    let (local bool_s_140550) = is_zero(s-140550)
    let (local bool_s_43200) = is_zero(s-43200)
    let (local bool_s_28800) = is_zero(s-28800)
    let (local bool_s_72100) = is_zero(s-72100)
    let (local bool_s_56930) = is_zero(s-56930)
    let (local bool_s_36900) = is_zero(s-36900)
    let (local bool_s_4110) = is_zero(s-4110)
    let (local bool_s_149740) = is_zero(s-149740)
    let (local bool_s_150130) = is_zero(s-150130)
    let (local bool_s_77150) = is_zero(s-77150)
    let (local bool_s_44570) = is_zero(s-44570)
    let (local bool_s_162000) = is_zero(s-162000)
    let (local bool_s_116820) = is_zero(s-116820)
    let (local bool_s_172270) = is_zero(s-172270)
    let (local bool_s_135340) = is_zero(s-135340)
    let (local bool_s_8910) = is_zero(s-8910)
    let (local bool_s_133000) = is_zero(s-133000)
    let (local bool_s_9350) = is_zero(s-9350)
    let (local bool_s_113610) = is_zero(s-113610)
    let (local bool_s_47570) = is_zero(s-47570)
    let (local bool_s_75080) = is_zero(s-75080)
    let (local bool_s_133120) = is_zero(s-133120)
    let (local bool_s_174520) = is_zero(s-174520)
    let (local bool_s_52790) = is_zero(s-52790)
    let (local bool_s_16320) = is_zero(s-16320)
    let (local bool_s_160400) = is_zero(s-160400)
    let (local bool_s_1370) = is_zero(s-1370)
    let (local bool_s_82450) = is_zero(s-82450)
    let (local bool_s_48060) = is_zero(s-48060)
    let (local bool_s_93230) = is_zero(s-93230)
    let (local bool_s_52920) = is_zero(s-52920)
    let (local bool_s_58350) = is_zero(s-58350)
    let (local bool_s_82150) = is_zero(s-82150)
    let (local bool_s_9590) = is_zero(s-9590)
    let (local bool_s_67290) = is_zero(s-67290)
    let (local bool_s_8820) = is_zero(s-8820)
    let (local bool_s_149950) = is_zero(s-149950)
    let (local bool_s_80740) = is_zero(s-80740)
    let (local bool_s_84290) = is_zero(s-84290)
    let (local bool_s_108630) = is_zero(s-108630)
    let (local bool_s_52700) = is_zero(s-52700)
    let (local bool_s_128560) = is_zero(s-128560)
    let (local bool_s_140610) = is_zero(s-140610)
    let (local bool_s_16620) = is_zero(s-16620)
    let (local bool_s_74450) = is_zero(s-74450)
    let (local bool_s_38450) = is_zero(s-38450)
    let (local bool_s_183250) = is_zero(s-183250)
    let (local bool_s_16560) = is_zero(s-16560)
    let (local bool_s_79490) = is_zero(s-79490)
    let (local bool_s_89660) = is_zero(s-89660)
    let (local bool_s_13980) = is_zero(s-13980)
    let (local bool_s_28620) = is_zero(s-28620)
    let (local bool_s_70610) = is_zero(s-70610)
    let (local bool_s_23680) = is_zero(s-23680)
    let (local bool_s_75290) = is_zero(s-75290)
    let (local bool_s_13860) = is_zero(s-13860)
    let (local bool_s_125930) = is_zero(s-125930)
    let (local bool_s_108680) = is_zero(s-108680)
    let (local bool_s_45450) = is_zero(s-45450)
    let (local bool_s_186940) = is_zero(s-186940)
    let (local bool_s_43900) = is_zero(s-43900)
    let (local bool_s_86760) = is_zero(s-86760)
    let (local bool_s_48170) = is_zero(s-48170)
    let (local bool_s_27620) = is_zero(s-27620)
    let (local bool_s_1690) = is_zero(s-1690)
    let (local bool_s_6570) = is_zero(s-6570)
    let (local bool_s_59240) = is_zero(s-59240)
    let (local bool_s_1830) = is_zero(s-1830)
    let (local bool_s_133060) = is_zero(s-133060)
    let (local bool_s_75250) = is_zero(s-75250)
    let (local bool_s_2250) = is_zero(s-2250)
    let (local bool_s_6120) = is_zero(s-6120)
    let (local bool_s_81020) = is_zero(s-81020)
    let (local bool_s_123330) = is_zero(s-123330)
    let (local bool_s_154980) = is_zero(s-154980)
    let (local bool_s_13800) = is_zero(s-13800)
    let (local bool_s_60) = is_zero(s-60)
    let (local bool_s_133480) = is_zero(s-133480)
    let (local bool_s_162630) = is_zero(s-162630)
    let (local bool_s_75240) = is_zero(s-75240)
    let (local bool_s_142620) = is_zero(s-142620)
    let (local bool_s_45720) = is_zero(s-45720)
    let (local bool_s_111960) = is_zero(s-111960)
    let (local bool_s_47800) = is_zero(s-47800)
    let (local bool_s_9120) = is_zero(s-9120)
    let (local bool_s_120870) = is_zero(s-120870)
    let (local bool_s_48340) = is_zero(s-48340)
    let (local bool_s_85190) = is_zero(s-85190)
    let (local bool_s_2490) = is_zero(s-2490)
    let (local bool_s_108960) = is_zero(s-108960)
    let (local bool_s_137050) = is_zero(s-137050)
    let (local bool_s_11880) = is_zero(s-11880)
    let (local bool_s_142710) = is_zero(s-142710)
    let (local bool_s_290) = is_zero(s-290)
    let (local bool_s_5000) = is_zero(s-5000)
    let (local bool_s_7310) = is_zero(s-7310)
    let (local bool_s_18740) = is_zero(s-18740)
    let (local bool_s_108830) = is_zero(s-108830)
    let (local bool_s_150430) = is_zero(s-150430)
    let (local bool_s_9380) = is_zero(s-9380)
    let (local bool_s_15150) = is_zero(s-15150)
    let (local bool_s_89300) = is_zero(s-89300)
    let (local bool_s_125650) = is_zero(s-125650)
    let (local bool_s_140680) = is_zero(s-140680)
    let (local bool_s_135280) = is_zero(s-135280)
    let (local bool_s_11810) = is_zero(s-11810)
    let (local bool_s_55080) = is_zero(s-55080)
    let (local bool_s_20520) = is_zero(s-20520)
    let (local bool_s_69680) = is_zero(s-69680)
    let (local bool_s_86150) = is_zero(s-86150)
    let (local bool_s_45680) = is_zero(s-45680)
    let (local bool_s_121410) = is_zero(s-121410)
    let (local bool_s_40790) = is_zero(s-40790)
    let (local bool_s_135910) = is_zero(s-135910)
    let (local bool_s_9020) = is_zero(s-9020)
    let (local bool_s_111290) = is_zero(s-111290)
    let (local bool_s_38210) = is_zero(s-38210)
    let (local bool_s_5900) = is_zero(s-5900)
    let (local bool_s_132100) = is_zero(s-132100)
    let (local bool_s_162210) = is_zero(s-162210)
    let (local bool_s_153090) = is_zero(s-153090)
    let (local bool_s_121440) = is_zero(s-121440)
    let (local bool_s_168550) = is_zero(s-168550)
    let (local bool_s_106920) = is_zero(s-106920)
    let (local bool_s_107750) = is_zero(s-107750)
    let (local bool_s_172060) = is_zero(s-172060)
    let (local bool_s_154870) = is_zero(s-154870)
    let (local bool_s_47690) = is_zero(s-47690)
    let (local bool_s_154710) = is_zero(s-154710)
    let (local bool_s_146700) = is_zero(s-146700)
    let (local bool_s_50260) = is_zero(s-50260)
    let (local bool_s_74700) = is_zero(s-74700)
    let (local bool_s_135430) = is_zero(s-135430)
    let (local bool_s_9200) = is_zero(s-9200)
    let (local bool_s_51180) = is_zero(s-51180)
    let (local bool_s_81170) = is_zero(s-81170)
    let (local bool_s_57870) = is_zero(s-57870)
    let (local bool_s_18770) = is_zero(s-18770)
    let (local bool_s_123170) = is_zero(s-123170)
    let (local bool_s_108590) = is_zero(s-108590)
    let (local bool_s_6820) = is_zero(s-6820)
    let (local bool_s_5020) = is_zero(s-5020)
    let (local bool_s_150) = is_zero(s-150)
    let (local bool_s_184510) = is_zero(s-184510)
    let (local bool_s_140350) = is_zero(s-140350)
    let (local bool_s_25730) = is_zero(s-25730)
    let (local bool_s_179020) = is_zero(s-179020)
    let (local bool_s_159730) = is_zero(s-159730)
    let (local bool_s_165180) = is_zero(s-165180)
    let (local bool_s_169720) = is_zero(s-169720)
    let (local bool_s_16210) = is_zero(s-16210)
    let (local bool_s_129920) = is_zero(s-129920)
    let (local bool_s_114350) = is_zero(s-114350)
    let (local bool_s_16580) = is_zero(s-16580)
    let (local bool_s_147520) = is_zero(s-147520)
    let (local bool_s_119020) = is_zero(s-119020)
    let (local bool_s_145090) = is_zero(s-145090)
    let (local bool_s_52970) = is_zero(s-52970)
    let (local bool_s_2040) = is_zero(s-2040)
    let (local bool_s_146620) = is_zero(s-146620)
    let (local bool_s_149860) = is_zero(s-149860)
    let (local bool_s_167020) = is_zero(s-167020)
    let (local bool_s_11690) = is_zero(s-11690)
    let (local bool_s_66150) = is_zero(s-66150)
    let (local bool_s_132580) = is_zero(s-132580)
    let (local bool_s_65110) = is_zero(s-65110)
    let (local bool_s_27890) = is_zero(s-27890)
    let (local bool_s_7470) = is_zero(s-7470)
    let (local bool_s_168590) = is_zero(s-168590)
    let (local bool_s_103680) = is_zero(s-103680)
    let (local bool_s_186220) = is_zero(s-186220)
    let (local bool_s_108860) = is_zero(s-108860)
    let (local bool_s_24080) = is_zero(s-24080)
    let (local bool_s_23660) = is_zero(s-23660)
    let (local bool_s_16500) = is_zero(s-16500)
    let (local bool_s_20630) = is_zero(s-20630)
    let (local bool_s_550) = is_zero(s-550)
    let (local bool_s_4200) = is_zero(s-4200)
    let (local bool_s_107030) = is_zero(s-107030)
    let (local bool_s_123440) = is_zero(s-123440)
    let (local bool_s_114300) = is_zero(s-114300)
    let (local bool_s_24030) = is_zero(s-24030)
    let (local bool_s_140160) = is_zero(s-140160)
    let (local bool_s_8960) = is_zero(s-8960)
    let (local bool_s_162180) = is_zero(s-162180)
    let (local bool_s_11950) = is_zero(s-11950)
    let (local bool_s_700) = is_zero(s-700)
    let (local bool_s_155410) = is_zero(s-155410)
    let (local bool_s_11540) = is_zero(s-11540)
    let (local bool_s_55710) = is_zero(s-55710)
    let (local bool_s_86770) = is_zero(s-86770)
    let (local bool_s_55630) = is_zero(s-55630)
    let (local bool_s_67020) = is_zero(s-67020)
    let (local bool_s_23670) = is_zero(s-23670)
    let (local bool_s_57200) = is_zero(s-57200)
    let (local bool_s_1650) = is_zero(s-1650)
    let (local bool_s_190) = is_zero(s-190)
    let (local bool_s_183610) = is_zero(s-183610)
    let (local bool_s_67880) = is_zero(s-67880)
    let (local bool_s_9100) = is_zero(s-9100)
    let (local bool_s_59270) = is_zero(s-59270)
    let (local bool_s_12910) = is_zero(s-12910)
    let (local bool_s_9450) = is_zero(s-9450)
    let (local bool_s_45630) = is_zero(s-45630)
    let (local bool_s_186100) = is_zero(s-186100)
    let (local bool_s_69890) = is_zero(s-69890)
    let (local bool_s_131310) = is_zero(s-131310)
    let (local bool_s_147850) = is_zero(s-147850)
    let (local bool_s_74760) = is_zero(s-74760)
    let (local bool_s_38710) = is_zero(s-38710)
    let (local bool_s_18630) = is_zero(s-18630)
    let (local bool_s_120920) = is_zero(s-120920)
    let (local bool_s_1730) = is_zero(s-1730)
    let (local bool_s_70470) = is_zero(s-70470)
    let (local bool_s_139550) = is_zero(s-139550)
    let (local bool_s_52650) = is_zero(s-52650)
    let (local bool_s_45740) = is_zero(s-45740)
    let (local bool_s_21890) = is_zero(s-21890)
    let (local bool_s_14580) = is_zero(s-14580)
    let (local bool_s_35990) = is_zero(s-35990)
    let (local bool_s_160990) = is_zero(s-160990)
    let (local bool_s_67400) = is_zero(s-67400)
    let (local bool_s_81810) = is_zero(s-81810)
    let (local bool_s_72500) = is_zero(s-72500)
    let (local bool_s_82130) = is_zero(s-82130)
    let (local bool_s_140220) = is_zero(s-140220)
    let (local bool_s_45400) = is_zero(s-45400)
    let (local bool_s_118260) = is_zero(s-118260)
    let (local bool_s_15410) = is_zero(s-15410)
    let (local bool_s_43030) = is_zero(s-43030)
    let (local bool_s_145350) = is_zero(s-145350)
    let (local bool_s_125960) = is_zero(s-125960)
    let (local bool_s_570) = is_zero(s-570)
    let (local bool_s_45100) = is_zero(s-45100)
    let (local bool_s_28440) = is_zero(s-28440)
    let (local bool_s_143320) = is_zero(s-143320)
    let (local bool_s_131490) = is_zero(s-131490)
    let (local bool_s_172360) = is_zero(s-172360)
    let (local bool_s_124790) = is_zero(s-124790)
    let (local bool_s_70) = is_zero(s-70)
    let (local bool_s_118280) = is_zero(s-118280)
    let (local bool_s_13770) = is_zero(s-13770)
    let (local bool_s_47790) = is_zero(s-47790)
    let (local bool_s_131410) = is_zero(s-131410)
    let (local bool_s_174250) = is_zero(s-174250)
    let (local bool_s_38160) = is_zero(s-38160)
    let (local bool_s_103730) = is_zero(s-103730)
    let (local bool_s_79610) = is_zero(s-79610)
    let (local bool_s_130770) = is_zero(s-130770)
    let (local bool_s_64310) = is_zero(s-64310)
    let (local bool_s_14190) = is_zero(s-14190)
    let (local bool_s_108690) = is_zero(s-108690)
    let (local bool_s_136030) = is_zero(s-136030)
    let (local bool_s_44600) = is_zero(s-44600)
    let (local bool_s_450) = is_zero(s-450)
    let (local bool_s_131440) = is_zero(s-131440)
    let (local bool_s_185720) = is_zero(s-185720)
    let (local bool_s_81900) = is_zero(s-81900)
    let (local bool_s_123130) = is_zero(s-123130)
    let (local bool_s_70430) = is_zero(s-70430)
    let (local bool_s_135270) = is_zero(s-135270)
    let (local bool_s_140400) = is_zero(s-140400)
    let (local bool_s_71930) = is_zero(s-71930)
    let (local bool_s_5130) = is_zero(s-5130)
    let (local bool_s_72470) = is_zero(s-72470)
    let (local bool_s_171990) = is_zero(s-171990)
    let (local bool_s_74330) = is_zero(s-74330)
    let (local bool_s_111650) = is_zero(s-111650)
    let (local bool_s_16020) = is_zero(s-16020)
    let (local bool_s_150280) = is_zero(s-150280)
    let (local bool_s_1840) = is_zero(s-1840)
    let (local bool_s_52680) = is_zero(s-52680)
    let (local bool_s_123410) = is_zero(s-123410)
    let (local bool_s_77690) = is_zero(s-77690)
    let (local bool_s_9060) = is_zero(s-9060)
    let (local bool_s_12110) = is_zero(s-12110)
    let (local bool_s_43880) = is_zero(s-43880)
    let (local bool_s_133650) = is_zero(s-133650)
    let (local bool_s_9660) = is_zero(s-9660)
    let (local bool_s_67580) = is_zero(s-67580)
    let (local bool_s_82390) = is_zero(s-82390)
    let (local bool_s_130720) = is_zero(s-130720)
    let (local bool_s_23640) = is_zero(s-23640)
    let (local bool_s_20390) = is_zero(s-20390)
    let (local bool_s_49730) = is_zero(s-49730)
    let (local bool_s_118220) = is_zero(s-118220)
    let (local bool_s_132870) = is_zero(s-132870)
    let (local bool_s_8980) = is_zero(s-8980)
    let (local bool_s_136090) = is_zero(s-136090)
    let (local bool_s_142560) = is_zero(s-142560)
    let (local bool_s_67780) = is_zero(s-67780)
    let (local bool_s_79400) = is_zero(s-79400)
    let (local bool_s_170) = is_zero(s-170)
    let (local bool_s_9140) = is_zero(s-9140)

    tempvar sop_2 = bool_a_0 * bool_s_0 * 136 + bool_a_0 * bool_s_1620 * 100 + bool_a_0 * bool_s_67230 * 180
    tempvar sop_5 = bool_a_0 * bool_s_4860 * 111 + bool_a_0 * bool_s_140220 * 189 + bool_a_0 * bool_s_38160 * 100
    tempvar sop_8 = bool_a_0 * bool_s_131220 * 103 + bool_a_0 * bool_s_80190 * 175 + bool_a_0 * bool_s_130800 * 149
    tempvar sop_11 = bool_a_0 * bool_s_140610 * 149 + bool_a_0 * bool_s_57630 * 174 + bool_a_0 * bool_s_81900 * 144
    tempvar sop_14 = bool_a_0 * bool_s_14190 * 149 + bool_a_1 * bool_s_9090 * 100 + bool_a_1 * bool_s_147790 * 174
    tempvar sop_17 = bool_a_1 * bool_s_52740 * 100 + bool_a_1 * bool_s_107750 * 149 + bool_a_1 * bool_s_183970 * 199
    tempvar sop_20 = bool_a_1 * bool_s_172360 * 149 + bool_a_1 * bool_s_140770 * 199 + bool_a_1 * bool_s_186940 * 193
    tempvar sop_23 = bool_a_1 * bool_s_168590 * 149 + bool_a_1 * bool_s_133480 * 199 + bool_a_1 * bool_s_147520 * 199
    tempvar sop_26 = bool_a_1 * bool_s_174250 * 199 + bool_a_1 * bool_s_38710 * 174 + bool_a_1 * bool_s_153920 * 149
    tempvar sop_29 = bool_a_1 * bool_s_145090 * 149 + bool_a_1 * bool_s_169930 * 193 + bool_a_1 * bool_s_57610 * 149
    tempvar sop_32 = bool_a_1 * bool_s_147250 * 174 + bool_a_1 * bool_s_184510 * 149 + bool_a_1 * bool_s_152650 * 199
    tempvar sop_35 = bool_a_1 * bool_s_176680 * 199 + bool_a_1 * bool_s_125650 * 196 + bool_a_1 * bool_s_86770 * 174
    tempvar sop_38 = bool_a_1 * bool_s_161390 * 149 + bool_a_1 * bool_s_82450 * 199 + bool_a_1 * bool_s_65170 * 187
    tempvar sop_41 = bool_a_1 * bool_s_138070 * 149 + bool_a_1 * bool_s_174520 * 149 + bool_a_1 * bool_s_144010 * 149
    tempvar sop_44 = bool_a_1 * bool_s_37280 * 149 + bool_a_2 * bool_s_0 * 121 + bool_a_2 * bool_s_82100 * 100
    tempvar sop_47 = bool_a_2 * bool_s_8910 * 159 + bool_a_2 * bool_s_81820 * 189 + bool_a_2 * bool_s_132850 * 100
    tempvar sop_50 = bool_a_2 * bool_s_23490 * 100 + bool_a_2 * bool_s_169300 * 100 + bool_a_2 * bool_s_21340 * 145
    tempvar sop_53 = bool_a_2 * bool_s_69680 * 149 + bool_a_2 * bool_s_133120 * 122 + bool_a_2 * bool_s_169870 * 149
    tempvar sop_56 = bool_a_2 * bool_s_113150 * 174 + bool_a_2 * bool_s_184450 * 149 + bool_a_2 * bool_s_138510 * 160
    tempvar sop_59 = bool_a_2 * bool_s_132580 * 122 + bool_a_2 * bool_s_186100 * 149 + bool_a_2 * bool_s_74330 * 149
    tempvar sop_62 = bool_a_2 * bool_s_92150 * 149 + bool_a_2 * bool_s_84310 * 149 + bool_a_2 * bool_s_130720 * 149
    tempvar sop_65 = bool_a_2 * bool_s_128560 * 149 + bool_a_3 * bool_s_6490 * 102 + bool_a_3 * bool_s_183970 * 149
    tempvar sop_68 = bool_a_3 * bool_s_166870 * 149 + bool_a_3 * bool_s_140350 * 149 + bool_a_3 * bool_s_185720 * 149
    tempvar sop_71 = bool_a_3 * bool_s_61670 * 149 + bool_a_3 * bool_s_145090 * 199 + bool_a_3 * bool_s_140290 * 199
    tempvar sop_74 = bool_a_3 * bool_s_149190 * 149 + bool_a_3 * bool_s_149210 * 149 + bool_a_3 * bool_s_137800 * 189
    tempvar sop_77 = bool_a_3 * bool_s_145150 * 149 + bool_a_3 * bool_s_13990 * 149 + bool_a_3 * bool_s_167020 * 149
    tempvar sop_80 = bool_a_3 * bool_s_140200 * 149 + bool_a_3 * bool_s_55270 * 149 + bool_a_4 * bool_s_51180 * 149
    tempvar sop_83 = bool_a_4 * bool_s_80740 * 149 + bool_a_5 * bool_s_110180 * 122 + bool_a_5 * bool_s_82250 * 199
    tempvar sop_86 = bool_a_5 * bool_s_140770 * 100 + bool_a_5 * bool_s_81970 * 199 + bool_a_5 * bool_s_104120 * 149
    tempvar sop_89 = bool_a_5 * bool_s_125240 * 149 + bool_a_5 * bool_s_125930 * 199 + bool_a_5 * bool_s_81960 * 149
    tempvar sop_92 = bool_a_5 * bool_s_81950 * 149 + bool_a_5 * bool_s_111650 * 149 + bool_a_5 * bool_s_9540 * 100
    tempvar sop_95 = bool_a_5 * bool_s_125960 * 149 + bool_a_5 * bool_s_125650 * 174 + bool_a_5 * bool_s_82450 * 149
    tempvar sop_98 = bool_a_5 * bool_s_109980 * 149 + bool_a_5 * bool_s_74690 * 149 + bool_a_6 * bool_s_0 * 167
    tempvar sop_101 = bool_a_6 * bool_s_1710 * 180 + bool_a_6 * bool_s_180 * 100 + bool_a_6 * bool_s_110 * 176
    tempvar sop_104 = bool_a_6 * bool_s_160000 * 149 + bool_a_6 * bool_s_43830 * 100 + bool_a_6 * bool_s_131310 * 160
    tempvar sop_107 = bool_a_6 * bool_s_89300 * 149 + bool_a_6 * bool_s_67420 * 186 + bool_a_6 * bool_s_137980 * 149
    tempvar sop_110 = bool_a_6 * bool_s_70620 * 122 + bool_a_6 * bool_s_93230 * 149 + bool_a_6 * bool_s_137050 * 149
    tempvar sop_113 = bool_a_7 * bool_s_0 * 100 + bool_a_7 * bool_s_1710 * 100 + bool_a_7 * bool_s_135050 * 149
    tempvar sop_116 = bool_a_7 * bool_s_75290 * 199 + bool_a_7 * bool_s_79590 * 149 + bool_a_7 * bool_s_75240 * 149
    tempvar sop_119 = bool_a_7 * bool_s_14670 * 100 + bool_a_7 * bool_s_77670 * 149 + bool_a_7 * bool_s_79400 * 149
    tempvar sop_122 = bool_a_7 * bool_s_74750 * 149 + bool_a_7 * bool_s_79490 * 199 + bool_a_7 * bool_s_77690 * 149
    tempvar sop_125 = bool_a_7 * bool_s_79530 * 174 + bool_a_7 * bool_s_75250 * 199 + bool_a_7 * bool_s_79610 * 198
    tempvar sop_128 = bool_a_8 * bool_s_0 * 152 + bool_a_8 * bool_s_1620 * 100 + bool_a_8 * bool_s_1630 * 180
    tempvar sop_131 = bool_a_8 * bool_s_47690 * 149 + bool_a_8 * bool_s_14590 * 175 + bool_a_8 * bool_s_30800 * 149
    tempvar sop_134 = bool_a_8 * bool_s_9140 * 100 + bool_a_8 * bool_s_31530 * 149 + bool_a_8 * bool_s_30960 * 149
    tempvar sop_137 = bool_a_8 * bool_s_9020 * 167 + bool_a_8 * bool_s_14740 * 122 + bool_a_8 * bool_s_41200 * 149
    tempvar sop_140 = bool_a_8 * bool_s_4160 * 149 + bool_a_8 * bool_s_12030 * 174 + bool_a_8 * bool_s_31470 * 149
    tempvar sop_143 = bool_a_8 * bool_s_18720 * 149 + bool_a_8 * bool_s_46800 * 149 + bool_a_8 * bool_s_30980 * 174
    tempvar sop_145 = bool_a_8 * bool_s_45100 * 149 + bool_a_8 * bool_s_18740 * 149
    tempvar sop = sop_2 + sop_5 + sop_8 + sop_11 + sop_14 + sop_17 + sop_20 + sop_23 + sop_26 + sop_29 + sop_32 + sop_35 + sop_38 + sop_41 + sop_44 + sop_47 + sop_50 + sop_53 + sop_56 + sop_59 + sop_62 + sop_65 + sop_68 + sop_71 + sop_74 + sop_77 + sop_80 + sop_83 + sop_86 + sop_89 + sop_92 + sop_95 + sop_98 + sop_101 + sop_104 + sop_107 + sop_110 + sop_113 + sop_116 + sop_119 + sop_122 + sop_125 + sop_128 + sop_131 + sop_134 + sop_137 + sop_140 + sop_143 + sop_145

    return (q = sop)
end