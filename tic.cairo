%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.storage import Storage
from starkware.cairo.common.math import unsigned_div_rem
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
    }(
        x : felt,
        y : felt
    ) -> (
        z : felt
    ):
    let (z) = board.read(x,y)
    return (z)
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
    let (b_0_0) = board.read(0,0)
    let (b_0_1) = board.read(0,1)
    let (b_0_2) = board.read(0,2)
    let (b_1_0) = board.read(1,0)
    let (b_1_1) = board.read(1,1)
    let (b_1_2) = board.read(1,2)
    let (b_2_0) = board.read(2,0)
    let (b_2_1) = board.read(2,1)
    let (b_2_2) = board.read(2,2)
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

    # O(N) finding argmax
    local q_max_0 = q_a_0
    local argmax_0 = 0

    let (local bool_le_1) = is_le(q_max_0, q_a_1)
    local q_max_1 = bool_le_1 * q_a_1 + (1-bool_le_1) * q_max_0
    local argmax_1 = bool_le_1 * 1 + (1-bool_le_1) * argmax_0

    let (local bool_le_2) = is_le(q_max_1, q_a_2)
    local q_max_2 = bool_le_2 * q_a_2 + (1-bool_le_2) * q_max_1
    local argmax_2 = bool_le_2 * 2 + (1-bool_le_2) * argmax_1

    let (local bool_le_3) = is_le(q_max_2, q_a_3)
    local q_max_3 = bool_le_3 * q_a_3 + (1-bool_le_3) * q_max_2
    local argmax_3 = bool_le_3 * 3 + (1-bool_le_3) * argmax_2

    let (local bool_le_4) = is_le(q_max_3, q_a_4)
    local q_max_4 = bool_le_4 * q_a_4 + (1-bool_le_4) * q_max_3
    local argmax_4 = bool_le_4 * 4 + (1-bool_le_4) * argmax_3

    let (local bool_le_5) = is_le(q_max_4, q_a_5)
    local q_max_5 = bool_le_5 * q_a_5 + (1-bool_le_5) * q_max_4
    local argmax_5 = bool_le_5 * 5 + (1-bool_le_5) * argmax_4

    let (local bool_le_6) = is_le(q_max_5, q_a_6)
    local q_max_6 = bool_le_6 * q_a_6 + (1-bool_le_6) * q_max_5
    local argmax_6 = bool_le_6 * 6 + (1-bool_le_6) * argmax_5

    let (local bool_le_7) = is_le(q_max_6, q_a_7)
    local q_max_7 = bool_le_7 * q_a_7 + (1-bool_le_7) * q_max_6
    local argmax_7 = bool_le_7 * 7 + (1-bool_le_7) * argmax_6

    let (local bool_le_8) = is_le(q_max_7, q_a_8)
    local q_max_8 = bool_le_8 * q_a_8 + (1-bool_le_8) * q_max_7
    local argmax_8 = bool_le_8 * 8 + (1-bool_le_8) * argmax_7

    local q_max = q_max_8
    local argmax = argmax_8

    # 5. decode AI's encoded action into AI move
    let (x_ai, y_ai) = unsigned_div_rem (argmax, 3)

    # 6. update board with AI move (AI is 1)
    let (ai_move_cell) = board.read(x_ai, y_ai)
    assert ai_move_cell = 0
    board.write(x_ai, y_ai, 1)
    let (ai_move_cell_done) = board.read(x_ai, y_ai)
    assert ai_move_cell_done = 1

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

@external
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

    let (local bool_0) = is_zero( (a-0) + (s-0) )
    let (local bool_1) = is_zero( (a-0) + (s-1620) )
    let (local bool_2) = is_zero( (a-0) + (s-67230) )
    let (local bool_3) = is_zero( (a-0) + (s-4860) )
    let (local bool_4) = is_zero( (a-0) + (s-140220) )
    let (local bool_5) = is_zero( (a-0) + (s-38160) )
    let (local bool_6) = is_zero( (a-0) + (s-131220) )
    let (local bool_7) = is_zero( (a-0) + (s-80190) )
    let (local bool_8) = is_zero( (a-0) + (s-130800) )
    let (local bool_9) = is_zero( (a-0) + (s-140610) )
    let (local bool_10) = is_zero( (a-0) + (s-57630) )
    let (local bool_11) = is_zero( (a-0) + (s-81900) )
    let (local bool_12) = is_zero( (a-0) + (s-14190) )
    let (local bool_13) = is_zero( (a-1) + (s-9090) )
    let (local bool_14) = is_zero( (a-1) + (s-147790) )
    let (local bool_15) = is_zero( (a-1) + (s-52740) )
    let (local bool_16) = is_zero( (a-1) + (s-107750) )
    let (local bool_17) = is_zero( (a-1) + (s-183970) )
    let (local bool_18) = is_zero( (a-1) + (s-172360) )
    let (local bool_19) = is_zero( (a-1) + (s-140770) )
    let (local bool_20) = is_zero( (a-1) + (s-186940) )
    let (local bool_21) = is_zero( (a-1) + (s-168590) )
    let (local bool_22) = is_zero( (a-1) + (s-133480) )
    let (local bool_23) = is_zero( (a-1) + (s-147520) )
    let (local bool_24) = is_zero( (a-1) + (s-174250) )
    let (local bool_25) = is_zero( (a-1) + (s-38710) )
    let (local bool_26) = is_zero( (a-1) + (s-153920) )
    let (local bool_27) = is_zero( (a-1) + (s-145090) )
    let (local bool_28) = is_zero( (a-1) + (s-169930) )
    let (local bool_29) = is_zero( (a-1) + (s-57610) )
    let (local bool_30) = is_zero( (a-1) + (s-147250) )
    let (local bool_31) = is_zero( (a-1) + (s-184510) )
    let (local bool_32) = is_zero( (a-1) + (s-152650) )
    let (local bool_33) = is_zero( (a-1) + (s-176680) )
    let (local bool_34) = is_zero( (a-1) + (s-125650) )
    let (local bool_35) = is_zero( (a-1) + (s-86770) )
    let (local bool_36) = is_zero( (a-1) + (s-161390) )
    let (local bool_37) = is_zero( (a-1) + (s-82450) )
    let (local bool_38) = is_zero( (a-1) + (s-65170) )
    let (local bool_39) = is_zero( (a-1) + (s-138070) )
    let (local bool_40) = is_zero( (a-1) + (s-174520) )
    let (local bool_41) = is_zero( (a-1) + (s-144010) )
    let (local bool_42) = is_zero( (a-1) + (s-37280) )
    let (local bool_43) = is_zero( (a-2) + (s-0) )
    let (local bool_44) = is_zero( (a-2) + (s-82100) )
    let (local bool_45) = is_zero( (a-2) + (s-8910) )
    let (local bool_46) = is_zero( (a-2) + (s-81820) )
    let (local bool_47) = is_zero( (a-2) + (s-132850) )
    let (local bool_48) = is_zero( (a-2) + (s-23490) )
    let (local bool_49) = is_zero( (a-2) + (s-169300) )
    let (local bool_50) = is_zero( (a-2) + (s-21340) )
    let (local bool_51) = is_zero( (a-2) + (s-69680) )
    let (local bool_52) = is_zero( (a-2) + (s-133120) )
    let (local bool_53) = is_zero( (a-2) + (s-169870) )
    let (local bool_54) = is_zero( (a-2) + (s-113150) )
    let (local bool_55) = is_zero( (a-2) + (s-184450) )
    let (local bool_56) = is_zero( (a-2) + (s-138510) )
    let (local bool_57) = is_zero( (a-2) + (s-132580) )
    let (local bool_58) = is_zero( (a-2) + (s-186100) )
    let (local bool_59) = is_zero( (a-2) + (s-74330) )
    let (local bool_60) = is_zero( (a-2) + (s-92150) )
    let (local bool_61) = is_zero( (a-2) + (s-84310) )
    let (local bool_62) = is_zero( (a-2) + (s-130720) )
    let (local bool_63) = is_zero( (a-2) + (s-128560) )
    let (local bool_64) = is_zero( (a-3) + (s-6490) )
    let (local bool_65) = is_zero( (a-3) + (s-183970) )
    let (local bool_66) = is_zero( (a-3) + (s-166870) )
    let (local bool_67) = is_zero( (a-3) + (s-140350) )
    let (local bool_68) = is_zero( (a-3) + (s-185720) )
    let (local bool_69) = is_zero( (a-3) + (s-61670) )
    let (local bool_70) = is_zero( (a-3) + (s-145090) )
    let (local bool_71) = is_zero( (a-3) + (s-140290) )
    let (local bool_72) = is_zero( (a-3) + (s-149190) )
    let (local bool_73) = is_zero( (a-3) + (s-149210) )
    let (local bool_74) = is_zero( (a-3) + (s-137800) )
    let (local bool_75) = is_zero( (a-3) + (s-145150) )
    let (local bool_76) = is_zero( (a-3) + (s-13990) )
    let (local bool_77) = is_zero( (a-3) + (s-167020) )
    let (local bool_78) = is_zero( (a-3) + (s-140200) )
    let (local bool_79) = is_zero( (a-3) + (s-55270) )
    let (local bool_80) = is_zero( (a-4) + (s-51180) )
    let (local bool_81) = is_zero( (a-4) + (s-80740) )
    let (local bool_82) = is_zero( (a-5) + (s-110180) )
    let (local bool_83) = is_zero( (a-5) + (s-82250) )
    let (local bool_84) = is_zero( (a-5) + (s-140770) )
    let (local bool_85) = is_zero( (a-5) + (s-81970) )
    let (local bool_86) = is_zero( (a-5) + (s-104120) )
    let (local bool_87) = is_zero( (a-5) + (s-125240) )
    let (local bool_88) = is_zero( (a-5) + (s-125930) )
    let (local bool_89) = is_zero( (a-5) + (s-81960) )
    let (local bool_90) = is_zero( (a-5) + (s-81950) )
    let (local bool_91) = is_zero( (a-5) + (s-111650) )
    let (local bool_92) = is_zero( (a-5) + (s-9540) )
    let (local bool_93) = is_zero( (a-5) + (s-125960) )
    let (local bool_94) = is_zero( (a-5) + (s-125650) )
    let (local bool_95) = is_zero( (a-5) + (s-82450) )
    let (local bool_96) = is_zero( (a-5) + (s-109980) )
    let (local bool_97) = is_zero( (a-5) + (s-74690) )
    let (local bool_98) = is_zero( (a-6) + (s-0) )
    let (local bool_99) = is_zero( (a-6) + (s-1710) )
    let (local bool_100) = is_zero( (a-6) + (s-180) )
    let (local bool_101) = is_zero( (a-6) + (s-110) )
    let (local bool_102) = is_zero( (a-6) + (s-160000) )
    let (local bool_103) = is_zero( (a-6) + (s-43830) )
    let (local bool_104) = is_zero( (a-6) + (s-131310) )
    let (local bool_105) = is_zero( (a-6) + (s-89300) )
    let (local bool_106) = is_zero( (a-6) + (s-67420) )
    let (local bool_107) = is_zero( (a-6) + (s-137980) )
    let (local bool_108) = is_zero( (a-6) + (s-70620) )
    let (local bool_109) = is_zero( (a-6) + (s-93230) )
    let (local bool_110) = is_zero( (a-6) + (s-137050) )
    let (local bool_111) = is_zero( (a-7) + (s-0) )
    let (local bool_112) = is_zero( (a-7) + (s-1710) )
    let (local bool_113) = is_zero( (a-7) + (s-135050) )
    let (local bool_114) = is_zero( (a-7) + (s-75290) )
    let (local bool_115) = is_zero( (a-7) + (s-79590) )
    let (local bool_116) = is_zero( (a-7) + (s-75240) )
    let (local bool_117) = is_zero( (a-7) + (s-14670) )
    let (local bool_118) = is_zero( (a-7) + (s-77670) )
    let (local bool_119) = is_zero( (a-7) + (s-79400) )
    let (local bool_120) = is_zero( (a-7) + (s-74750) )
    let (local bool_121) = is_zero( (a-7) + (s-79490) )
    let (local bool_122) = is_zero( (a-7) + (s-77690) )
    let (local bool_123) = is_zero( (a-7) + (s-79530) )
    let (local bool_124) = is_zero( (a-7) + (s-75250) )
    let (local bool_125) = is_zero( (a-7) + (s-79610) )
    let (local bool_126) = is_zero( (a-8) + (s-0) )
    let (local bool_127) = is_zero( (a-8) + (s-1620) )
    let (local bool_128) = is_zero( (a-8) + (s-1630) )
    let (local bool_129) = is_zero( (a-8) + (s-47690) )
    let (local bool_130) = is_zero( (a-8) + (s-14590) )
    let (local bool_131) = is_zero( (a-8) + (s-30800) )
    let (local bool_132) = is_zero( (a-8) + (s-9140) )
    let (local bool_133) = is_zero( (a-8) + (s-31530) )
    let (local bool_134) = is_zero( (a-8) + (s-30960) )
    let (local bool_135) = is_zero( (a-8) + (s-9020) )
    let (local bool_136) = is_zero( (a-8) + (s-14740) )
    let (local bool_137) = is_zero( (a-8) + (s-41200) )
    let (local bool_138) = is_zero( (a-8) + (s-4160) )
    let (local bool_139) = is_zero( (a-8) + (s-12030) )
    let (local bool_140) = is_zero( (a-8) + (s-31470) )
    let (local bool_141) = is_zero( (a-8) + (s-18720) )
    let (local bool_142) = is_zero( (a-8) + (s-46800) )
    let (local bool_143) = is_zero( (a-8) + (s-30980) )
    let (local bool_144) = is_zero( (a-8) + (s-45100) )
    let (local bool_145) = is_zero( (a-8) + (s-18740) )

    tempvar sop = bool_0 * 136 + bool_1 * 100 + bool_2 * 180 + bool_3 * 111 + bool_4 * 189 + bool_5 * 100 + bool_6 * 103 + bool_7 * 175 + bool_8 * 149 + bool_9 * 149 + bool_10 * 174 + bool_11 * 144 + bool_12 * 149 + bool_13 * 100 + bool_14 * 174 + bool_15 * 100 + bool_16 * 149 + bool_17 * 199 + bool_18 * 149 + bool_19 * 199 + bool_20 * 193 + bool_21 * 149 + bool_22 * 199 + bool_23 * 199 + bool_24 * 199 + bool_25 * 174 + bool_26 * 149 + bool_27 * 149 + bool_28 * 193 + bool_29 * 149 + bool_30 * 174 + bool_31 * 149 + bool_32 * 199 + bool_33 * 199 + bool_34 * 196 + bool_35 * 174 + bool_36 * 149 + bool_37 * 199 + bool_38 * 187 + bool_39 * 149 + bool_40 * 149 + bool_41 * 149 + bool_42 * 149 + bool_43 * 121 + bool_44 * 100 + bool_45 * 159 + bool_46 * 189 + bool_47 * 100 + bool_48 * 100 + bool_49 * 100 + bool_50 * 145 + bool_51 * 149 + bool_52 * 122 + bool_53 * 149 + bool_54 * 174 + bool_55 * 149 + bool_56 * 160 + bool_57 * 122 + bool_58 * 149 + bool_59 * 149 + bool_60 * 149 + bool_61 * 149 + bool_62 * 149 + bool_63 * 149 + bool_64 * 102 + bool_65 * 149 + bool_66 * 149 + bool_67 * 149 + bool_68 * 149 + bool_69 * 149 + bool_70 * 199 + bool_71 * 199 + bool_72 * 149 + bool_73 * 149 + bool_74 * 189 + bool_75 * 149 + bool_76 * 149 + bool_77 * 149 + bool_78 * 149 + bool_79 * 149 + bool_80 * 149 + bool_81 * 149 + bool_82 * 122 + bool_83 * 199 + bool_84 * 100 + bool_85 * 199 + bool_86 * 149 + bool_87 * 149 + bool_88 * 199 + bool_89 * 149 + bool_90 * 149 + bool_91 * 149 + bool_92 * 100 + bool_93 * 149 + bool_94 * 174 + bool_95 * 149 + bool_96 * 149 + bool_97 * 149 + bool_98 * 167 + bool_99 * 180 + bool_100 * 100 + bool_101 * 176 + bool_102 * 149 + bool_103 * 100 + bool_104 * 160 + bool_105 * 149 + bool_106 * 186 + bool_107 * 149 + bool_108 * 122 + bool_109 * 149 + bool_110 * 149 + bool_111 * 100 + bool_112 * 100 + bool_113 * 149 + bool_114 * 199 + bool_115 * 149 + bool_116 * 149 + bool_117 * 100 + bool_118 * 149 + bool_119 * 149 + bool_120 * 149 + bool_121 * 199 + bool_122 * 149 + bool_123 * 174 + bool_124 * 199 + bool_125 * 198 + bool_126 * 152 + bool_127 * 100 + bool_128 * 180 + bool_129 * 149 + bool_130 * 175 + bool_131 * 149 + bool_132 * 100 + bool_133 * 149 + bool_134 * 149 + bool_135 * 167 + bool_136 * 122 + bool_137 * 149 + bool_138 * 149 + bool_139 * 174 + bool_140 * 149 + bool_141 * 149 + bool_142 * 149 + bool_143 * 174 + bool_144 * 149 + bool_145 * 149

    return (q = sop)
end