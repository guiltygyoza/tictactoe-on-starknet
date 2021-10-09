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
    local s = s_0 + s_1 + s_2

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

    let (local bool_a_0) = is_zero(a-0)
    let (local bool_a_1) = is_zero(a-1)
    let (local bool_a_2) = is_zero(a-2)
    let (local bool_a_3) = is_zero(a-3)
    let (local bool_a_4) = is_zero(a-4)
    let (local bool_a_5) = is_zero(a-5)
    let (local bool_a_6) = is_zero(a-6)
    let (local bool_a_7) = is_zero(a-7)
    let (local bool_a_8) = is_zero(a-8)

    let (local bool_s_5508) = is_zero(s-5508)
    let (local bool_s_4375) = is_zero(s-4375)
    let (local bool_s_13210) = is_zero(s-13210)
    let (local bool_s_8633) = is_zero(s-8633)
    let (local bool_s_7193) = is_zero(s-7193)
    let (local bool_s_407) = is_zero(s-407)
    let (local bool_s_3651) = is_zero(s-3651)
    let (local bool_s_8519) = is_zero(s-8519)
    let (local bool_s_15028) = is_zero(s-15028)
    let (local bool_s_15558) = is_zero(s-15558)
    let (local bool_s_14061) = is_zero(s-14061)
    let (local bool_s_11849) = is_zero(s-11849)
    let (local bool_s_440) = is_zero(s-440)
    let (local bool_s_14005) = is_zero(s-14005)
    let (local bool_s_16200) = is_zero(s-16200)
    let (local bool_s_6429) = is_zero(s-6429)
    let (local bool_s_3834) = is_zero(s-3834)
    let (local bool_s_11102) = is_zero(s-11102)
    let (local bool_s_405) = is_zero(s-405)
    let (local bool_s_13330) = is_zero(s-13330)
    let (local bool_s_2351) = is_zero(s-2351)
    let (local bool_s_167) = is_zero(s-167)
    let (local bool_s_2) = is_zero(s-2)
    let (local bool_s_11855) = is_zero(s-11855)
    let (local bool_s_1872) = is_zero(s-1872)
    let (local bool_s_1661) = is_zero(s-1661)
    let (local bool_s_1632) = is_zero(s-1632)
    let (local bool_s_16930) = is_zero(s-16930)
    let (local bool_s_14020) = is_zero(s-14020)
    let (local bool_s_16987) = is_zero(s-16987)
    let (local bool_s_11718) = is_zero(s-11718)
    let (local bool_s_14515) = is_zero(s-14515)
    let (local bool_s_4383) = is_zero(s-4383)
    let (local bool_s_4806) = is_zero(s-4806)
    let (local bool_s_263) = is_zero(s-263)
    let (local bool_s_17152) = is_zero(s-17152)
    let (local bool_s_14262) = is_zero(s-14262)
    let (local bool_s_10863) = is_zero(s-10863)
    let (local bool_s_13348) = is_zero(s-13348)
    let (local bool_s_1636) = is_zero(s-1636)
    let (local bool_s_920) = is_zero(s-920)
    let (local bool_s_5118) = is_zero(s-5118)
    let (local bool_s_4320) = is_zero(s-4320)
    let (local bool_s_6984) = is_zero(s-6984)
    let (local bool_s_15973) = is_zero(s-15973)
    let (local bool_s_6022) = is_zero(s-6022)
    let (local bool_s_13318) = is_zero(s-13318)
    let (local bool_s_11363) = is_zero(s-11363)
    let (local bool_s_2134) = is_zero(s-2134)
    let (local bool_s_101) = is_zero(s-101)
    let (local bool_s_1874) = is_zero(s-1874)
    let (local bool_s_13077) = is_zero(s-13077)
    let (local bool_s_4537) = is_zero(s-4537)
    let (local bool_s_17350) = is_zero(s-17350)
    let (local bool_s_18) = is_zero(s-18)
    let (local bool_s_3690) = is_zero(s-3690)
    let (local bool_s_332) = is_zero(s-332)
    let (local bool_s_1206) = is_zero(s-1206)
    let (local bool_s_3151) = is_zero(s-3151)
    let (local bool_s_15265) = is_zero(s-15265)
    let (local bool_s_16504) = is_zero(s-16504)
    let (local bool_s_5945) = is_zero(s-5945)
    let (local bool_s_3821) = is_zero(s-3821)
    let (local bool_s_2368) = is_zero(s-2368)
    let (local bool_s_21) = is_zero(s-21)
    let (local bool_s_6768) = is_zero(s-6768)
    let (local bool_s_8184) = is_zero(s-8184)
    let (local bool_s_8966) = is_zero(s-8966)
    let (local bool_s_297) = is_zero(s-297)
    let (local bool_s_13527) = is_zero(s-13527)
    let (local bool_s_15768) = is_zero(s-15768)
    let (local bool_s_7) = is_zero(s-7)
    let (local bool_s_8239) = is_zero(s-8239)
    let (local bool_s_5504) = is_zero(s-5504)
    let (local bool_s_1662) = is_zero(s-1662)
    let (local bool_s_3153) = is_zero(s-3153)
    let (local bool_s_6579) = is_zero(s-6579)
    let (local bool_s_4628) = is_zero(s-4628)
    let (local bool_s_5207) = is_zero(s-5207)
    let (local bool_s_2418) = is_zero(s-2418)
    let (local bool_s_181) = is_zero(s-181)
    let (local bool_s_3849) = is_zero(s-3849)
    let (local bool_s_6698) = is_zero(s-6698)
    let (local bool_s_1291) = is_zero(s-1291)
    let (local bool_s_14401) = is_zero(s-14401)
    let (local bool_s_7041) = is_zero(s-7041)
    let (local bool_s_177) = is_zero(s-177)
    let (local bool_s_12144) = is_zero(s-12144)
    let (local bool_s_7241) = is_zero(s-7241)
    let (local bool_s_7061) = is_zero(s-7061)
    let (local bool_s_7445) = is_zero(s-7445)
    let (local bool_s_13435) = is_zero(s-13435)
    let (local bool_s_16461) = is_zero(s-16461)
    let (local bool_s_3818) = is_zero(s-3818)
    let (local bool_s_7223) = is_zero(s-7223)
    let (local bool_s_70) = is_zero(s-70)
    let (local bool_s_10397) = is_zero(s-10397)
    let (local bool_s_191) = is_zero(s-191)
    let (local bool_s_2034) = is_zero(s-2034)
    let (local bool_s_17368) = is_zero(s-17368)
    let (local bool_s_2762) = is_zero(s-2762)
    let (local bool_s_13780) = is_zero(s-13780)
    let (local bool_s_13955) = is_zero(s-13955)
    let (local bool_s_4568) = is_zero(s-4568)
    let (local bool_s_16218) = is_zero(s-16218)
    let (local bool_s_15714) = is_zero(s-15714)
    let (local bool_s_11361) = is_zero(s-11361)
    let (local bool_s_11315) = is_zero(s-11315)
    let (local bool_s_13536) = is_zero(s-13536)
    let (local bool_s_12509) = is_zero(s-12509)
    let (local bool_s_5341) = is_zero(s-5341)
    let (local bool_s_8597) = is_zero(s-8597)
    let (local bool_s_8695) = is_zero(s-8695)
    let (local bool_s_5132) = is_zero(s-5132)
    let (local bool_s_7961) = is_zero(s-7961)
    let (local bool_s_6741) = is_zero(s-6741)
    let (local bool_s_17181) = is_zero(s-17181)
    let (local bool_s_10998) = is_zero(s-10998)
    let (local bool_s_5052) = is_zero(s-5052)
    let (local bool_s_13149) = is_zero(s-13149)
    let (local bool_s_200) = is_zero(s-200)
    let (local bool_s_10808) = is_zero(s-10808)
    let (local bool_s_13543) = is_zero(s-13543)
    let (local bool_s_7250) = is_zero(s-7250)
    let (local bool_s_10370) = is_zero(s-10370)
    let (local bool_s_5274) = is_zero(s-5274)
    let (local bool_s_2851) = is_zero(s-2851)
    let (local bool_s_162) = is_zero(s-162)
    let (local bool_s_10896) = is_zero(s-10896)
    let (local bool_s_16270) = is_zero(s-16270)
    let (local bool_s_1203) = is_zero(s-1203)
    let (local bool_s_173) = is_zero(s-173)
    let (local bool_s_783) = is_zero(s-783)
    let (local bool_s_15747) = is_zero(s-15747)
    let (local bool_s_57) = is_zero(s-57)
    let (local bool_s_13306) = is_zero(s-13306)
    let (local bool_s_9413) = is_zero(s-9413)
    let (local bool_s_4512) = is_zero(s-4512)
    let (local bool_s_12141) = is_zero(s-12141)
    let (local bool_s_6440) = is_zero(s-6440)
    let (local bool_s_15783) = is_zero(s-15783)
    let (local bool_s_5315) = is_zero(s-5315)
    let (local bool_s_13549) = is_zero(s-13549)
    let (local bool_s_938) = is_zero(s-938)
    let (local bool_s_8429) = is_zero(s-8429)
    let (local bool_s_137) = is_zero(s-137)
    let (local bool_s_13884) = is_zero(s-13884)
    let (local bool_s_14770) = is_zero(s-14770)
    let (local bool_s_17188) = is_zero(s-17188)
    let (local bool_s_902) = is_zero(s-902)
    let (local bool_s_430) = is_zero(s-430)
    let (local bool_s_12092) = is_zero(s-12092)
    let (local bool_s_165) = is_zero(s-165)
    let (local bool_s_2364) = is_zero(s-2364)
    let (local bool_s_194) = is_zero(s-194)
    let (local bool_s_13382) = is_zero(s-13382)
    let (local bool_s_183) = is_zero(s-183)
    let (local bool_s_13880) = is_zero(s-13880)
    let (local bool_s_8102) = is_zero(s-8102)
    let (local bool_s_16993) = is_zero(s-16993)
    let (local bool_s_1480) = is_zero(s-1480)
    let (local bool_s_14055) = is_zero(s-14055)
    let (local bool_s_12587) = is_zero(s-12587)
    let (local bool_s_12524) = is_zero(s-12524)
    let (local bool_s_486) = is_zero(s-486)
    let (local bool_s_4680) = is_zero(s-4680)
    let (local bool_s_15480) = is_zero(s-15480)
    let (local bool_s_7210) = is_zero(s-7210)
    let (local bool_s_7953) = is_zero(s-7953)
    let (local bool_s_15001) = is_zero(s-15001)
    let (local bool_s_18622) = is_zero(s-18622)
    let (local bool_s_189) = is_zero(s-189)
    let (local bool_s_14725) = is_zero(s-14725)
    let (local bool_s_3823) = is_zero(s-3823)
    let (local bool_s_4800) = is_zero(s-4800)
    let (local bool_s_11126) = is_zero(s-11126)
    let (local bool_s_6758) = is_zero(s-6758)
    let (local bool_s_682) = is_zero(s-682)
    let (local bool_s_3096) = is_zero(s-3096)
    let (local bool_s_657) = is_zero(s-657)
    let (local bool_s_5571) = is_zero(s-5571)
    let (local bool_s_18388) = is_zero(s-18388)
    let (local bool_s_5927) = is_zero(s-5927)
    let (local bool_s_680) = is_zero(s-680)
    let (local bool_s_11390) = is_zero(s-11390)
    let (local bool_s_5529) = is_zero(s-5529)
    let (local bool_s_954) = is_zero(s-954)
    let (local bool_s_14919) = is_zero(s-14919)
    let (local bool_s_4780) = is_zero(s-4780)
    let (local bool_s_651) = is_zero(s-651)
    let (local bool_s_4334) = is_zero(s-4334)
    let (local bool_s_8192) = is_zero(s-8192)
    let (local bool_s_10883) = is_zero(s-10883)
    let (local bool_s_18451) = is_zero(s-18451)
    let (local bool_s_6723) = is_zero(s-6723)
    let (local bool_s_612) = is_zero(s-612)
    let (local bool_s_4896) = is_zero(s-4896)
    let (local bool_s_1648) = is_zero(s-1648)
    let (local bool_s_1550) = is_zero(s-1550)
    let (local bool_s_17452) = is_zero(s-17452)
    let (local bool_s_3147) = is_zero(s-3147)
    let (local bool_s_1474) = is_zero(s-1474)
    let (local bool_s_1684) = is_zero(s-1684)
    let (local bool_s_6778) = is_zero(s-6778)
    let (local bool_s_16219) = is_zero(s-16219)
    let (local bool_s_5265) = is_zero(s-5265)
    let (local bool_s_747) = is_zero(s-747)
    let (local bool_s_184) = is_zero(s-184)
    let (local bool_s_89) = is_zero(s-89)
    let (local bool_s_6) = is_zero(s-6)
    let (local bool_s_5720) = is_zero(s-5720)
    let (local bool_s_4752) = is_zero(s-4752)
    let (local bool_s_6517) = is_zero(s-6517)
    let (local bool_s_1386) = is_zero(s-1386)
    let (local bool_s_3871) = is_zero(s-3871)
    let (local bool_s_7472) = is_zero(s-7472)
    let (local bool_s_3812) = is_zero(s-3812)
    let (local bool_s_16957) = is_zero(s-16957)
    let (local bool_s_6004) = is_zero(s-6004)
    let (local bool_s_16206) = is_zero(s-16206)
    let (local bool_s_1422) = is_zero(s-1422)
    let (local bool_s_15490) = is_zero(s-15490)
    let (local bool_s_12089) = is_zero(s-12089)
    let (local bool_s_2835) = is_zero(s-2835)
    let (local bool_s_11889) = is_zero(s-11889)
    let (local bool_s_1314) = is_zero(s-1314)
    let (local bool_s_2403) = is_zero(s-2403)
    let (local bool_s_12558) = is_zero(s-12558)
    let (local bool_s_18226) = is_zero(s-18226)
    let (local bool_s_4256) = is_zero(s-4256)
    let (local bool_s_18397) = is_zero(s-18397)
    let (local bool_s_4779) = is_zero(s-4779)
    let (local bool_s_4617) = is_zero(s-4617)
    let (local bool_s_487) = is_zero(s-487)
    let (local bool_s_178) = is_zero(s-178)
    let (local bool_s_3645) = is_zero(s-3645)
    let (local bool_s_8969) = is_zero(s-8969)
    let (local bool_s_16040) = is_zero(s-16040)
    let (local bool_s_14022) = is_zero(s-14022)
    let (local bool_s_15013) = is_zero(s-15013)
    let (local bool_s_4050) = is_zero(s-4050)
    let (local bool_s_14256) = is_zero(s-14256)
    let (local bool_s_11385) = is_zero(s-11385)
    let (local bool_s_18572) = is_zero(s-18572)
    let (local bool_s_13705) = is_zero(s-13705)
    let (local bool_s_12142) = is_zero(s-12142)
    let (local bool_s_13122) = is_zero(s-13122)
    let (local bool_s_1515) = is_zero(s-1515)
    let (local bool_s_12485) = is_zero(s-12485)
    let (local bool_s_16000) = is_zero(s-16000)
    let (local bool_s_6744) = is_zero(s-6744)
    let (local bool_s_83) = is_zero(s-83)
    let (local bool_s_18649) = is_zero(s-18649)
    let (local bool_s_3851) = is_zero(s-3851)
    let (local bool_s_11682) = is_zero(s-11682)
    let (local bool_s_675) = is_zero(s-675)
    let (local bool_s_959) = is_zero(s-959)
    let (local bool_s_9227) = is_zero(s-9227)
    let (local bool_s_13505) = is_zero(s-13505)
    let (local bool_s_15021) = is_zero(s-15021)
    let (local bool_s_4769) = is_zero(s-4769)
    let (local bool_s_416) = is_zero(s-416)
    let (local bool_s_18610) = is_zero(s-18610)
    let (local bool_s_802) = is_zero(s-802)
    let (local bool_s_8630) = is_zero(s-8630)
    let (local bool_s_7039) = is_zero(s-7039)
    let (local bool_s_5297) = is_zero(s-5297)
    let (local bool_s_14271) = is_zero(s-14271)
    let (local bool_s_420) = is_zero(s-420)
    let (local bool_s_7529) = is_zero(s-7529)
    let (local bool_s_896) = is_zero(s-896)
    let (local bool_s_1207) = is_zero(s-1207)
    let (local bool_s_11826) = is_zero(s-11826)
    let (local bool_s_249) = is_zero(s-249)
    let (local bool_s_5924) = is_zero(s-5924)
    let (local bool_s_1157) = is_zero(s-1157)
    let (local bool_s_884) = is_zero(s-884)
    let (local bool_s_1647) = is_zero(s-1647)
    let (local bool_s_15537) = is_zero(s-15537)
    let (local bool_s_11837) = is_zero(s-11837)
    let (local bool_s_2366) = is_zero(s-2366)
    let (local bool_s_882) = is_zero(s-882)
    let (local bool_s_6729) = is_zero(s-6729)
    let (local bool_s_15526) = is_zero(s-15526)
    let (local bool_s_2054) = is_zero(s-2054)
    let (local bool_s_7209) = is_zero(s-7209)
    let (local bool_s_11124) = is_zero(s-11124)
    let (local bool_s_16261) = is_zero(s-16261)
    let (local bool_s_13554) = is_zero(s-13554)
    let (local bool_s_2349) = is_zero(s-2349)
    let (local bool_s_5158) = is_zero(s-5158)
    let (local bool_s_13300) = is_zero(s-13300)
    let (local bool_s_13123) = is_zero(s-13123)
    let (local bool_s_169) = is_zero(s-169)
    let (local bool_s_11876) = is_zero(s-11876)
    let (local bool_s_8197) = is_zero(s-8197)
    let (local bool_s_18361) = is_zero(s-18361)
    let (local bool_s_12856) = is_zero(s-12856)
    let (local bool_s_2149) = is_zero(s-2149)
    let (local bool_s_12559) = is_zero(s-12559)
    let (local bool_s_2063) = is_zero(s-2063)
    let (local bool_s_3814) = is_zero(s-3814)
    let (local bool_s_590) = is_zero(s-590)
    let (local bool_s_1539) = is_zero(s-1539)
    let (local bool_s_5531) = is_zero(s-5531)
    let (local bool_s_8676) = is_zero(s-8676)
    let (local bool_s_1194) = is_zero(s-1194)
    let (local bool_s_10869) = is_zero(s-10869)
    let (local bool_s_13560) = is_zero(s-13560)
    let (local bool_s_16855) = is_zero(s-16855)
    let (local bool_s_10692) = is_zero(s-10692)
    let (local bool_s_15729) = is_zero(s-15729)
    let (local bool_s_2880) = is_zero(s-2880)
    let (local bool_s_7949) = is_zero(s-7949)
    let (local bool_s_63) = is_zero(s-63)
    let (local bool_s_4390) = is_zero(s-4390)
    let (local bool_s_1169) = is_zero(s-1169)
    let (local bool_s_14670) = is_zero(s-14670)
    let (local bool_s_10368) = is_zero(s-10368)
    let (local bool_s_6702) = is_zero(s-6702)
    let (local bool_s_16044) = is_zero(s-16044)
    let (local bool_s_10887) = is_zero(s-10887)
    let (local bool_s_13603) = is_zero(s-13603)
    let (local bool_s_13507) = is_zero(s-13507)
    let (local bool_s_6431) = is_zero(s-6431)
    let (local bool_s_11611) = is_zero(s-11611)
    let (local bool_s_1406) = is_zero(s-1406)
    let (local bool_s_909) = is_zero(s-909)
    let (local bool_s_910) = is_zero(s-910)
    let (local bool_s_7182) = is_zero(s-7182)
    let (local bool_s_10886) = is_zero(s-10886)
    let (local bool_s_2844) = is_zero(s-2844)
    let (local bool_s_1419) = is_zero(s-1419)
    let (local bool_s_1158) = is_zero(s-1158)
    let (local bool_s_87) = is_zero(s-87)
    let (local bool_s_14035) = is_zero(s-14035)
    let (local bool_s_17662) = is_zero(s-17662)
    let (local bool_s_14332) = is_zero(s-14332)
    let (local bool_s_13141) = is_zero(s-13141)
    let (local bool_s_6740) = is_zero(s-6740)
    let (local bool_s_6986) = is_zero(s-6986)
    let (local bool_s_13285) = is_zero(s-13285)
    let (local bool_s_7062) = is_zero(s-7062)
    let (local bool_s_4329) = is_zero(s-4329)
    let (local bool_s_4457) = is_zero(s-4457)
    let (local bool_s_14995) = is_zero(s-14995)
    let (local bool_s_14921) = is_zero(s-14921)
    let (local bool_s_3845) = is_zero(s-3845)
    let (local bool_s_16255) = is_zero(s-16255)
    let (local bool_s_7228) = is_zero(s-7228)
    let (local bool_s_6728) = is_zero(s-6728)
    let (local bool_s_5268) = is_zero(s-5268)
    let (local bool_s_12971) = is_zero(s-12971)
    let (local bool_s_16073) = is_zero(s-16073)
    let (local bool_s_914) = is_zero(s-914)
    let (local bool_s_789) = is_zero(s-789)
    let (local bool_s_15487) = is_zero(s-15487)
    let (local bool_s_11097) = is_zero(s-11097)
    let (local bool_s_2354) = is_zero(s-2354)
    let (local bool_s_1195) = is_zero(s-1195)
    let (local bool_s_15478) = is_zero(s-15478)
    let (local bool_s_11619) = is_zero(s-11619)
    let (local bool_s_1377) = is_zero(s-1377)
    let (local bool_s_2573) = is_zero(s-2573)
    let (local bool_s_1127) = is_zero(s-1127)
    let (local bool_s_14662) = is_zero(s-14662)
    let (local bool_s_6615) = is_zero(s-6615)
    let (local bool_s_6989) = is_zero(s-6989)
    let (local bool_s_8699) = is_zero(s-8699)
    let (local bool_s_8019) = is_zero(s-8019)
    let (local bool_s_8703) = is_zero(s-8703)
    let (local bool_s_7508) = is_zero(s-7508)
    let (local bool_s_6650) = is_zero(s-6650)
    let (local bool_s_1398) = is_zero(s-1398)
    let (local bool_s_225) = is_zero(s-225)
    let (local bool_s_12350) = is_zero(s-12350)
    let (local bool_s_13144) = is_zero(s-13144)
    let (local bool_s_1399) = is_zero(s-1399)
    let (local bool_s_15777) = is_zero(s-15777)
    let (local bool_s_4120) = is_zero(s-4120)
    let (local bool_s_2836) = is_zero(s-2836)
    let (local bool_s_18694) = is_zero(s-18694)
    let (local bool_s_5292) = is_zero(s-5292)
    let (local bool_s_4079) = is_zero(s-4079)
    let (local bool_s_7940) = is_zero(s-7940)
    let (local bool_s_11881) = is_zero(s-11881)
    let (local bool_s_411) = is_zero(s-411)
    let (local bool_s_15043) = is_zero(s-15043)
    let (local bool_s_11883) = is_zero(s-11883)
    let (local bool_s_6725) = is_zero(s-6725)
    let (local bool_s_13591) = is_zero(s-13591)
    let (local bool_s_13131) = is_zero(s-13131)
    let (local bool_s_1215) = is_zero(s-1215)
    let (local bool_s_16215) = is_zero(s-16215)
    let (local bool_s_16687) = is_zero(s-16687)
    let (local bool_s_4331) = is_zero(s-4331)
    let (local bool_s_6742) = is_zero(s-6742)
    let (local bool_s_2360) = is_zero(s-2360)
    let (local bool_s_17179) = is_zero(s-17179)
    let (local bool_s_15157) = is_zero(s-15157)
    let (local bool_s_4460) = is_zero(s-4460)
    let (local bool_s_764) = is_zero(s-764)
    let (local bool_s_4582) = is_zero(s-4582)
    let (local bool_s_4558) = is_zero(s-4558)
    let (local bool_s_17748) = is_zero(s-17748)
    let (local bool_s_2419) = is_zero(s-2419)
    let (local bool_s_5537) = is_zero(s-5537)
    let (local bool_s_217) = is_zero(s-217)
    let (local bool_s_14249) = is_zero(s-14249)
    let (local bool_s_11621) = is_zero(s-11621)
    let (local bool_s_13428) = is_zero(s-13428)
    let (local bool_s_16099) = is_zero(s-16099)
    let (local bool_s_12998) = is_zero(s-12998)
    let (local bool_s_14016) = is_zero(s-14016)
    let (local bool_s_15769) = is_zero(s-15769)
    let (local bool_s_2039) = is_zero(s-2039)
    let (local bool_s_7220) = is_zero(s-7220)
    let (local bool_s_12341) = is_zero(s-12341)
    let (local bool_s_14040) = is_zero(s-14040)
    let (local bool_s_5787) = is_zero(s-5787)
    let (local bool_s_16945) = is_zero(s-16945)
    let (local bool_s_4574) = is_zero(s-4574)
    let (local bool_s_5773) = is_zero(s-5773)
    let (local bool_s_8210) = is_zero(s-8210)
    let (local bool_s_6167) = is_zero(s-6167)
    let (local bool_s_68) = is_zero(s-68)
    let (local bool_s_5407) = is_zero(s-5407)
    let (local bool_s_16139) = is_zero(s-16139)
    let (local bool_s_684) = is_zero(s-684)
    let (local bool_s_11018) = is_zero(s-11018)
    let (local bool_s_14535) = is_zero(s-14535)
    let (local bool_s_10868) = is_zero(s-10868)
    let (local bool_s_1152) = is_zero(s-1152)
    let (local bool_s_17199) = is_zero(s-17199)
    let (local bool_s_4563) = is_zero(s-4563)
    let (local bool_s_8710) = is_zero(s-8710)
    let (local bool_s_906) = is_zero(s-906)
    let (local bool_s_13851) = is_zero(s-13851)
    let (local bool_s_17236) = is_zero(s-17236)
    let (local bool_s_13798) = is_zero(s-13798)
    let (local bool_s_3599) = is_zero(s-3599)
    let (local bool_s_5563) = is_zero(s-5563)
    let (local bool_s_500) = is_zero(s-500)
    let (local bool_s_16263) = is_zero(s-16263)
    let (local bool_s_2408) = is_zero(s-2408)
    let (local bool_s_1467) = is_zero(s-1467)
    let (local bool_s_9215) = is_zero(s-9215)
    let (local bool_s_8225) = is_zero(s-8225)
    let (local bool_s_5763) = is_zero(s-5763)
    let (local bool_s_4754) = is_zero(s-4754)
    let (local bool_s_5026) = is_zero(s-5026)
    let (local bool_s_3807) = is_zero(s-3807)
    let (local bool_s_1658) = is_zero(s-1658)
    let (local bool_s_11) = is_zero(s-11)
    let (local bool_s_1181) = is_zero(s-1181)
    let (local bool_s_891) = is_zero(s-891)
    let (local bool_s_13582) = is_zero(s-13582)
    let (local bool_s_6730) = is_zero(s-6730)
    let (local bool_s_7715) = is_zero(s-7715)
    let (local bool_s_10521) = is_zero(s-10521)
    let (local bool_s_17902) = is_zero(s-17902)
    let (local bool_s_219) = is_zero(s-219)
    let (local bool_s_55) = is_zero(s-55)
    let (local bool_s_13807) = is_zero(s-13807)
    let (local bool_s_2669) = is_zero(s-2669)
    let (local bool_s_7767) = is_zero(s-7767)
    let (local bool_s_17227) = is_zero(s-17227)
    let (local bool_s_16516) = is_zero(s-16516)
    let (local bool_s_1458) = is_zero(s-1458)
    let (local bool_s_16859) = is_zero(s-16859)
    let (local bool_s_13288) = is_zero(s-13288)
    let (local bool_s_7475) = is_zero(s-7475)
    let (local bool_s_16518) = is_zero(s-16518)
    let (local bool_s_16127) = is_zero(s-16127)
    let (local bool_s_8615) = is_zero(s-8615)
    let (local bool_s_14785) = is_zero(s-14785)
    let (local bool_s_5835) = is_zero(s-5835)
    let (local bool_s_14683) = is_zero(s-14683)
    let (local bool_s_2355) = is_zero(s-2355)
    let (local bool_s_8196) = is_zero(s-8196)
    let (local bool_s_460) = is_zero(s-460)
    let (local bool_s_380) = is_zero(s-380)
    let (local bool_s_11822) = is_zero(s-11822)
    let (local bool_s_1621) = is_zero(s-1621)
    let (local bool_s_893) = is_zero(s-893)
    let (local bool_s_7130) = is_zero(s-7130)
    let (local bool_s_13258) = is_zero(s-13258)
    let (local bool_s_2367) = is_zero(s-2367)
    let (local bool_s_10859) = is_zero(s-10859)
    let (local bool_s_14974) = is_zero(s-14974)
    let (local bool_s_941) = is_zero(s-941)
    let (local bool_s_11902) = is_zero(s-11902)
    let (local bool_s_948) = is_zero(s-948)
    let (local bool_s_14083) = is_zero(s-14083)
    let (local bool_s_13534) = is_zero(s-13534)
    let (local bool_s_4510) = is_zero(s-4510)
    let (local bool_s_7524) = is_zero(s-7524)
    let (local bool_s_6030) = is_zero(s-6030)
    let (local bool_s_45) = is_zero(s-45)
    let (local bool_s_898) = is_zero(s-898)
    let (local bool_s_11165) = is_zero(s-11165)
    let (local bool_s_14326) = is_zero(s-14326)
    let (local bool_s_466) = is_zero(s-466)
    let (local bool_s_11129) = is_zero(s-11129)
    let (local bool_s_8705) = is_zero(s-8705)
    let (local bool_s_7236) = is_zero(s-7236)
    let (local bool_s_15471) = is_zero(s-15471)
    let (local bool_s_412) = is_zero(s-412)
    let (local bool_s_12596) = is_zero(s-12596)
    let (local bool_s_8213) = is_zero(s-8213)
    let (local bool_s_8930) = is_zero(s-8930)
    let (local bool_s_897) = is_zero(s-897)
    let (local bool_s_8117) = is_zero(s-8117)
    let (local bool_s_4973) = is_zero(s-4973)
    let (local bool_s_10775) = is_zero(s-10775)
    let (local bool_s_7525) = is_zero(s-7525)
    let (local bool_s_8677) = is_zero(s-8677)
    let (local bool_s_3132) = is_zero(s-3132)
    let (local bool_s_13080) = is_zero(s-13080)
    let (local bool_s_6511) = is_zero(s-6511)
    let (local bool_s_12179) = is_zero(s-12179)
    let (local bool_s_7238) = is_zero(s-7238)
    let (local bool_s_4539) = is_zero(s-4539)
    let (local bool_s_7458) = is_zero(s-7458)
    let (local bool_s_176) = is_zero(s-176)
    let (local bool_s_18325) = is_zero(s-18325)
    let (local bool_s_5558) = is_zero(s-5558)
    let (local bool_s_14029) = is_zero(s-14029)
    let (local bool_s_3840) = is_zero(s-3840)
    let (local bool_s_4757) = is_zero(s-4757)
    let (local bool_s_2276) = is_zero(s-2276)
    let (local bool_s_4572) = is_zero(s-4572)
    let (local bool_s_1602) = is_zero(s-1602)
    let (local bool_s_7454) = is_zero(s-7454)
    let (local bool_s_2789) = is_zero(s-2789)
    let (local bool_s_7259) = is_zero(s-7259)
    let (local bool_s_15958) = is_zero(s-15958)
    let (local bool_s_2842) = is_zero(s-2842)
    let (local bool_s_9323) = is_zero(s-9323)
    let (local bool_s_4834) = is_zero(s-4834)
    let (local bool_s_204) = is_zero(s-204)
    let (local bool_s_2142) = is_zero(s-2142)
    let (local bool_s_426) = is_zero(s-426)
    let (local bool_s_14319) = is_zero(s-14319)
    let (local bool_s_459) = is_zero(s-459)
    let (local bool_s_531) = is_zero(s-531)
    let (local bool_s_6746) = is_zero(s-6746)
    let (local bool_s_15498) = is_zero(s-15498)
    let (local bool_s_1343) = is_zero(s-1343)
    let (local bool_s_210) = is_zero(s-210)
    let (local bool_s_14994) = is_zero(s-14994)
    let (local bool_s_5527) = is_zero(s-5527)
    let (local bool_s_8074) = is_zero(s-8074)
    let (local bool_s_8514) = is_zero(s-8514)
    let (local bool_s_7047) = is_zero(s-7047)
    let (local bool_s_13590) = is_zero(s-13590)
    let (local bool_s_8186) = is_zero(s-8186)
    let (local bool_s_1391) = is_zero(s-1391)
    let (local bool_s_731) = is_zero(s-731)
    let (local bool_s_15309) = is_zero(s-15309)
    let (local bool_s_13072) = is_zero(s-13072)
    let (local bool_s_5922) = is_zero(s-5922)
    let (local bool_s_6213) = is_zero(s-6213)
    let (local bool_s_10374) = is_zero(s-10374)
    let (local bool_s_11828) = is_zero(s-11828)
    let (local bool_s_5279) = is_zero(s-5279)
    let (local bool_s_171) = is_zero(s-171)
    let (local bool_s_935) = is_zero(s-935)
    let (local bool_s_54) = is_zero(s-54)
    let (local bool_s_1650) = is_zero(s-1650)
    let (local bool_s_2052) = is_zero(s-2052)
    let (local bool_s_8181) = is_zero(s-8181)
    let (local bool_s_11831) = is_zero(s-11831)
    let (local bool_s_776) = is_zero(s-776)
    let (local bool_s_15472) = is_zero(s-15472)
    let (local bool_s_14068) = is_zero(s-14068)
    let (local bool_s_4388) = is_zero(s-4388)
    let (local bool_s_12974) = is_zero(s-12974)
    let (local bool_s_14509) = is_zero(s-14509)
    let (local bool_s_19) = is_zero(s-19)
    let (local bool_s_7469) = is_zero(s-7469)
    let (local bool_s_3816) = is_zero(s-3816)
    let (local bool_s_7476) = is_zero(s-7476)
    let (local bool_s_11430) = is_zero(s-11430)
    let (local bool_s_4798) = is_zero(s-4798)
    let (local bool_s_2356) = is_zero(s-2356)
    let (local bool_s_1634) = is_zero(s-1634)
    let (local bool_s_1270) = is_zero(s-1270)
    let (local bool_s_13312) = is_zero(s-13312)
    let (local bool_s_4321) = is_zero(s-4321)
    let (local bool_s_1544) = is_zero(s-1544)
    let (local bool_s_11098) = is_zero(s-11098)
    let (local bool_s_163) = is_zero(s-163)
    let (local bool_s_4309) = is_zero(s-4309)
    let (local bool_s_11847) = is_zero(s-11847)
    let (local bool_s_569) = is_zero(s-569)
    let (local bool_s_212) = is_zero(s-212)
    let (local bool_s_15784) = is_zero(s-15784)
    let (local bool_s_11435) = is_zero(s-11435)
    let (local bool_s_195) = is_zero(s-195)
    let (local bool_s_3908) = is_zero(s-3908)
    let (local bool_s_1136) = is_zero(s-1136)
    let (local bool_s_11597) = is_zero(s-11597)
    let (local bool_s_1154) = is_zero(s-1154)
    let (local bool_s_1380) = is_zero(s-1380)
    let (local bool_s_15) = is_zero(s-15)
    let (local bool_s_15190) = is_zero(s-15190)
    let (local bool_s_12150) = is_zero(s-12150)
    let (local bool_s_10865) = is_zero(s-10865)
    let (local bool_s_12992) = is_zero(s-12992)
    let (local bool_s_4374) = is_zero(s-4374)
    let (local bool_s_1415) = is_zero(s-1415)
    let (local bool_s_4336) = is_zero(s-4336)
    let (local bool_s_2425) = is_zero(s-2425)
    let (local bool_s_6773) = is_zero(s-6773)
    let (local bool_s_6770) = is_zero(s-6770)
    let (local bool_s_11119) = is_zero(s-11119)
    let (local bool_s_967) = is_zero(s-967)
    let (local bool_s_17206) = is_zero(s-17206)
    let (local bool_s_3877) = is_zero(s-3877)
    let (local bool_s_1487) = is_zero(s-1487)
    let (local bool_s_18445) = is_zero(s-18445)
    let (local bool_s_4577) = is_zero(s-4577)
    let (local bool_s_13380) = is_zero(s-13380)
    let (local bool_s_8245) = is_zero(s-8245)
    let (local bool_s_7247) = is_zero(s-7247)
    let (local bool_s_4801) = is_zero(s-4801)
    let (local bool_s_513) = is_zero(s-513)
    let (local bool_s_14013) = is_zero(s-14013)
    let (local bool_s_735) = is_zero(s-735)
    let (local bool_s_8038) = is_zero(s-8038)
    let (local bool_s_13133) = is_zero(s-13133)
    let (local bool_s_7110) = is_zero(s-7110)
    let (local bool_s_945) = is_zero(s-945)
    let (local bool_s_4817) = is_zero(s-4817)
    let (local bool_s_11106) = is_zero(s-11106)
    let (local bool_s_2412) = is_zero(s-2412)
    let (local bool_s_3743) = is_zero(s-3743)
    let (local bool_s_18382) = is_zero(s-18382)
    let (local bool_s_6752) = is_zero(s-6752)
    let (local bool_s_7959) = is_zero(s-7959)
    let (local bool_s_14077) = is_zero(s-14077)
    let (local bool_s_13311) = is_zero(s-13311)
    let (local bool_s_6788) = is_zero(s-6788)
    let (local bool_s_12317) = is_zero(s-12317)
    let (local bool_s_14752) = is_zero(s-14752)
    let (local bool_s_4545) = is_zero(s-4545)
    let (local bool_s_17910) = is_zero(s-17910)
    let (local bool_s_0) = is_zero(s-0)
    let (local bool_s_3810) = is_zero(s-3810)
    let (local bool_s_17214) = is_zero(s-17214)
    let (local bool_s_946) = is_zero(s-946)
    let (local bool_s_10935) = is_zero(s-10935)
    let (local bool_s_9431) = is_zero(s-9431)
    let (local bool_s_10870) = is_zero(s-10870)
    let (local bool_s_5761) = is_zero(s-5761)
    let (local bool_s_11615) = is_zero(s-11615)
    let (local bool_s_29) = is_zero(s-29)
    let (local bool_s_502) = is_zero(s-502)
    let (local bool_s_12313) = is_zero(s-12313)
    let (local bool_s_4550) = is_zero(s-4550)
    let (local bool_s_481) = is_zero(s-481)
    let (local bool_s_912) = is_zero(s-912)
    let (local bool_s_8190) = is_zero(s-8190)
    let (local bool_s_1140) = is_zero(s-1140)
    let (local bool_s_14034) = is_zero(s-14034)
    let (local bool_s_11666) = is_zero(s-11666)
    let (local bool_s_14311) = is_zero(s-14311)
    let (local bool_s_16221) = is_zero(s-16221)
    let (local bool_s_17668) = is_zero(s-17668)
    let (local bool_s_5121) = is_zero(s-5121)
    let (local bool_s_2193) = is_zero(s-2193)
    let (local bool_s_10892) = is_zero(s-10892)
    let (local bool_s_15392) = is_zero(s-15392)
    let (local bool_s_6974) = is_zero(s-6974)
    let (local bool_s_1863) = is_zero(s-1863)
    let (local bool_s_16972) = is_zero(s-16972)
    let (local bool_s_12087) = is_zero(s-12087)
    let (local bool_s_17425) = is_zero(s-17425)
    let (local bool_s_10703) = is_zero(s-10703)
    let (local bool_s_207) = is_zero(s-207)
    let (local bool_s_105) = is_zero(s-105)
    let (local bool_s_1623) = is_zero(s-1623)
    let (local bool_s_13287) = is_zero(s-13287)
    let (local bool_s_11610) = is_zero(s-11610)
    let (local bool_s_10375) = is_zero(s-10375)
    let (local bool_s_7218) = is_zero(s-7218)
    let (local bool_s_6777) = is_zero(s-6777)
    let (local bool_s_17173) = is_zero(s-17173)
    let (local bool_s_5231) = is_zero(s-5231)
    let (local bool_s_4540) = is_zero(s-4540)
    let (local bool_s_11765) = is_zero(s-11765)
    let (local bool_s_2189) = is_zero(s-2189)
    let (local bool_s_3098) = is_zero(s-3098)
    let (local bool_s_790) = is_zero(s-790)
    let (local bool_s_12593) = is_zero(s-12593)
    let (local bool_s_1459) = is_zero(s-1459)
    let (local bool_s_10373) = is_zero(s-10373)
    let (local bool_s_13320) = is_zero(s-13320)
    let (local bool_s_649) = is_zero(s-649)
    let (local bool_s_7013) = is_zero(s-7013)
    let (local bool_s_480) = is_zero(s-480)
    let (local bool_s_966) = is_zero(s-966)
    let (local bool_s_13528) = is_zero(s-13528)
    let (local bool_s_12476) = is_zero(s-12476)
    let (local bool_s_4303) = is_zero(s-4303)
    let (local bool_s_12565) = is_zero(s-12565)
    let (local bool_s_18423) = is_zero(s-18423)
    let (local bool_s_7058) = is_zero(s-7058)
    let (local bool_s_1987) = is_zero(s-1987)
    let (local bool_s_1656) = is_zero(s-1656)
    let (local bool_s_13584) = is_zero(s-13584)
    let (local bool_s_11885) = is_zero(s-11885)
    let (local bool_s_10412) = is_zero(s-10412)
    let (local bool_s_11340) = is_zero(s-11340)
    let (local bool_s_1630) = is_zero(s-1630)
    let (local bool_s_11624) = is_zero(s-11624)
    let (local bool_s_6968) = is_zero(s-6968)
    let (local bool_s_1541) = is_zero(s-1541)
    let (local bool_s_2404) = is_zero(s-2404)
    let (local bool_s_8431) = is_zero(s-8431)
    let (local bool_s_4484) = is_zero(s-4484)
    let (local bool_s_5286) = is_zero(s-5286)
    let (local bool_s_12333) = is_zero(s-12333)
    let (local bool_s_8588) = is_zero(s-8588)
    let (local bool_s_7043) = is_zero(s-7043)
    let (local bool_s_15541) = is_zero(s-15541)
    let (local bool_s_13293) = is_zero(s-13293)
    let (local bool_s_1877) = is_zero(s-1877)
    let (local bool_s_2651) = is_zero(s-2651)
    let (local bool_s_16702) = is_zero(s-16702)
    let (local bool_s_8182) = is_zero(s-8182)
    let (local bool_s_12344) = is_zero(s-12344)
    let (local bool_s_6876) = is_zero(s-6876)
    let (local bool_s_3080) = is_zero(s-3080)
    let (local bool_s_17) = is_zero(s-17)
    let (local bool_s_5693) = is_zero(s-5693)
    let (local bool_s_5270) = is_zero(s-5270)
    let (local bool_s_7038) = is_zero(s-7038)
    let (local bool_s_12326) = is_zero(s-12326)
    let (local bool_s_5103) = is_zero(s-5103)
    let (local bool_s_11844) = is_zero(s-11844)
    let (local bool_s_434) = is_zero(s-434)
    let (local bool_s_1663) = is_zero(s-1663)
    let (local bool_s_1629) = is_zero(s-1629)
    let (local bool_s_12479) = is_zero(s-12479)
    let (local bool_s_830) = is_zero(s-830)
    let (local bool_s_15720) = is_zero(s-15720)
    let (local bool_s_8195) = is_zero(s-8195)
    let (local bool_s_7470) = is_zero(s-7470)
    let (local bool_s_8683) = is_zero(s-8683)
    let (local bool_s_14986) = is_zero(s-14986)
    let (local bool_s_384) = is_zero(s-384)
    let (local bool_s_423) = is_zero(s-423)
    let (local bool_s_596) = is_zero(s-596)
    let (local bool_s_18399) = is_zero(s-18399)
    let (local bool_s_1211) = is_zero(s-1211)
    let (local bool_s_8426) = is_zero(s-8426)
    let (local bool_s_2862) = is_zero(s-2862)
    let (local bool_s_5584) = is_zero(s-5584)
    let (local bool_s_3822) = is_zero(s-3822)
    let (local bool_s_676) = is_zero(s-676)
    let (local bool_s_7433) = is_zero(s-7433)
    let (local bool_s_495) = is_zero(s-495)
    let (local bool_s_76) = is_zero(s-76)
    let (local bool_s_13979) = is_zero(s-13979)
    let (local bool_s_6567) = is_zero(s-6567)
    let (local bool_s_8708) = is_zero(s-8708)
    let (local bool_s_8215) = is_zero(s-8215)
    let (local bool_s_1188) = is_zero(s-1188)
    let (local bool_s_14779) = is_zero(s-14779)
    let (local bool_s_13609) = is_zero(s-13609)
    let (local bool_s_11196) = is_zero(s-11196)
    let (local bool_s_6780) = is_zero(s-6780)
    let (local bool_s_16963) = is_zero(s-16963)
    let (local bool_s_13597) = is_zero(s-13597)
    let (local bool_s_3728) = is_zero(s-3728)
    let (local bool_s_13365) = is_zero(s-13365)
    let (local bool_s_7769) = is_zero(s-7769)
    let (local bool_s_964) = is_zero(s-964)

    tempvar sop_2 = bool_a_0 * bool_s_0 * 136 + bool_a_0 * bool_s_162 * 100 + bool_a_0 * bool_s_6723 * 180
    tempvar sop_5 = bool_a_0 * bool_s_486 * 111 + bool_a_0 * bool_s_14022 * 189 + bool_a_0 * bool_s_3816 * 100
    tempvar sop_8 = bool_a_0 * bool_s_13122 * 103 + bool_a_0 * bool_s_8019 * 175 + bool_a_0 * bool_s_13080 * 149
    tempvar sop_11 = bool_a_0 * bool_s_14061 * 149 + bool_a_0 * bool_s_5763 * 174 + bool_a_0 * bool_s_8190 * 144
    tempvar sop_14 = bool_a_0 * bool_s_1419 * 149 + bool_a_1 * bool_s_909 * 100 + bool_a_1 * bool_s_14779 * 174
    tempvar sop_17 = bool_a_1 * bool_s_5274 * 100 + bool_a_1 * bool_s_10775 * 149 + bool_a_1 * bool_s_18397 * 199
    tempvar sop_20 = bool_a_1 * bool_s_17236 * 149 + bool_a_1 * bool_s_14077 * 199 + bool_a_1 * bool_s_18694 * 193
    tempvar sop_23 = bool_a_1 * bool_s_16859 * 149 + bool_a_1 * bool_s_13348 * 199 + bool_a_1 * bool_s_14752 * 199
    tempvar sop_26 = bool_a_1 * bool_s_17425 * 199 + bool_a_1 * bool_s_3871 * 174 + bool_a_1 * bool_s_15392 * 149
    tempvar sop_29 = bool_a_1 * bool_s_14509 * 149 + bool_a_1 * bool_s_16993 * 193 + bool_a_1 * bool_s_5761 * 149
    tempvar sop_32 = bool_a_1 * bool_s_14725 * 174 + bool_a_1 * bool_s_18451 * 149 + bool_a_1 * bool_s_15265 * 199
    tempvar sop_35 = bool_a_1 * bool_s_17668 * 199 + bool_a_1 * bool_s_12565 * 196 + bool_a_1 * bool_s_8677 * 174
    tempvar sop_38 = bool_a_1 * bool_s_16139 * 149 + bool_a_1 * bool_s_8245 * 199 + bool_a_1 * bool_s_6517 * 187
    tempvar sop_41 = bool_a_1 * bool_s_13807 * 149 + bool_a_1 * bool_s_17452 * 149 + bool_a_1 * bool_s_14401 * 149
    tempvar sop_44 = bool_a_1 * bool_s_3728 * 149 + bool_a_2 * bool_s_0 * 121 + bool_a_2 * bool_s_8210 * 100
    tempvar sop_47 = bool_a_2 * bool_s_891 * 159 + bool_a_2 * bool_s_8182 * 189 + bool_a_2 * bool_s_13285 * 100
    tempvar sop_50 = bool_a_2 * bool_s_2349 * 100 + bool_a_2 * bool_s_16930 * 100 + bool_a_2 * bool_s_2134 * 145
    tempvar sop_53 = bool_a_2 * bool_s_6968 * 149 + bool_a_2 * bool_s_13312 * 122 + bool_a_2 * bool_s_16987 * 149
    tempvar sop_56 = bool_a_2 * bool_s_11315 * 174 + bool_a_2 * bool_s_18445 * 149 + bool_a_2 * bool_s_13851 * 160
    tempvar sop_59 = bool_a_2 * bool_s_13258 * 122 + bool_a_2 * bool_s_18610 * 149 + bool_a_2 * bool_s_7433 * 149
    tempvar sop_62 = bool_a_2 * bool_s_9215 * 149 + bool_a_2 * bool_s_8431 * 149 + bool_a_2 * bool_s_13072 * 149
    tempvar sop_65 = bool_a_2 * bool_s_12856 * 149 + bool_a_3 * bool_s_649 * 102 + bool_a_3 * bool_s_18397 * 149
    tempvar sop_68 = bool_a_3 * bool_s_16687 * 149 + bool_a_3 * bool_s_14035 * 149 + bool_a_3 * bool_s_18572 * 149
    tempvar sop_71 = bool_a_3 * bool_s_6167 * 149 + bool_a_3 * bool_s_14509 * 199 + bool_a_3 * bool_s_14029 * 199
    tempvar sop_74 = bool_a_3 * bool_s_14919 * 149 + bool_a_3 * bool_s_14921 * 149 + bool_a_3 * bool_s_13780 * 189
    tempvar sop_77 = bool_a_3 * bool_s_14515 * 149 + bool_a_3 * bool_s_1399 * 149 + bool_a_3 * bool_s_16702 * 149
    tempvar sop_80 = bool_a_3 * bool_s_14020 * 149 + bool_a_3 * bool_s_5527 * 149 + bool_a_4 * bool_s_5118 * 149
    tempvar sop_83 = bool_a_4 * bool_s_8074 * 149 + bool_a_5 * bool_s_11018 * 122 + bool_a_5 * bool_s_8225 * 199
    tempvar sop_86 = bool_a_5 * bool_s_14077 * 100 + bool_a_5 * bool_s_8197 * 199 + bool_a_5 * bool_s_10412 * 149
    tempvar sop_89 = bool_a_5 * bool_s_12524 * 149 + bool_a_5 * bool_s_12593 * 199 + bool_a_5 * bool_s_8196 * 149
    tempvar sop_92 = bool_a_5 * bool_s_8195 * 149 + bool_a_5 * bool_s_11165 * 149 + bool_a_5 * bool_s_954 * 100
    tempvar sop_95 = bool_a_5 * bool_s_12596 * 149 + bool_a_5 * bool_s_12565 * 174 + bool_a_5 * bool_s_8245 * 149
    tempvar sop_98 = bool_a_5 * bool_s_10998 * 149 + bool_a_5 * bool_s_7469 * 149 + bool_a_6 * bool_s_0 * 167
    tempvar sop_101 = bool_a_6 * bool_s_171 * 180 + bool_a_6 * bool_s_18 * 100 + bool_a_6 * bool_s_11 * 176
    tempvar sop_104 = bool_a_6 * bool_s_16000 * 149 + bool_a_6 * bool_s_4383 * 100 + bool_a_6 * bool_s_13131 * 160
    tempvar sop_107 = bool_a_6 * bool_s_8930 * 149 + bool_a_6 * bool_s_6742 * 186 + bool_a_6 * bool_s_13798 * 149
    tempvar sop_110 = bool_a_6 * bool_s_7062 * 122 + bool_a_6 * bool_s_9323 * 149 + bool_a_6 * bool_s_13705 * 149
    tempvar sop_113 = bool_a_7 * bool_s_0 * 100 + bool_a_7 * bool_s_171 * 100 + bool_a_7 * bool_s_13505 * 149
    tempvar sop_116 = bool_a_7 * bool_s_7529 * 199 + bool_a_7 * bool_s_7959 * 149 + bool_a_7 * bool_s_7524 * 149
    tempvar sop_119 = bool_a_7 * bool_s_1467 * 100 + bool_a_7 * bool_s_7767 * 149 + bool_a_7 * bool_s_7940 * 149
    tempvar sop_122 = bool_a_7 * bool_s_7475 * 149 + bool_a_7 * bool_s_7949 * 199 + bool_a_7 * bool_s_7769 * 149
    tempvar sop_125 = bool_a_7 * bool_s_7953 * 174 + bool_a_7 * bool_s_7525 * 199 + bool_a_7 * bool_s_7961 * 198
    tempvar sop_128 = bool_a_8 * bool_s_0 * 152 + bool_a_8 * bool_s_162 * 100 + bool_a_8 * bool_s_163 * 180
    tempvar sop_131 = bool_a_8 * bool_s_4769 * 149 + bool_a_8 * bool_s_1459 * 175 + bool_a_8 * bool_s_3080 * 149
    tempvar sop_134 = bool_a_8 * bool_s_914 * 100 + bool_a_8 * bool_s_3153 * 149 + bool_a_8 * bool_s_3096 * 149
    tempvar sop_137 = bool_a_8 * bool_s_902 * 167 + bool_a_8 * bool_s_1474 * 122 + bool_a_8 * bool_s_4120 * 149
    tempvar sop_140 = bool_a_8 * bool_s_416 * 149 + bool_a_8 * bool_s_1203 * 174 + bool_a_8 * bool_s_3147 * 149
    tempvar sop_143 = bool_a_8 * bool_s_1872 * 149 + bool_a_8 * bool_s_4680 * 149 + bool_a_8 * bool_s_3098 * 174
    tempvar sop_145 = bool_a_8 * bool_s_4510 * 149 + bool_a_8 * bool_s_1874 * 149
    tempvar sop = sop_2 + sop_5 + sop_8 + sop_11 + sop_14 + sop_17 + sop_20 + sop_23 + sop_26 + sop_29 + sop_32 + sop_35 + sop_38 + sop_41 + sop_44 + sop_47 + sop_50 + sop_53 + sop_56 + sop_59 + sop_62 + sop_65 + sop_68 + sop_71 + sop_74 + sop_77 + sop_80 + sop_83 + sop_86 + sop_89 + sop_92 + sop_95 + sop_98 + sop_101 + sop_104 + sop_107 + sop_110 + sop_113 + sop_116 + sop_119 + sop_122 + sop_125 + sop_128 + sop_131 + sop_134 + sop_137 + sop_140 + sop_143 + sop_145

    return (q = sop)
end