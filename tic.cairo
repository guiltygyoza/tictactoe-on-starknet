%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.storage import Storage
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
        q_max : felt
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

    # 2. update board with user move (user is 1)
    board.write(x,y,1)
    let (user_move_cell_done) = board.read(x,y)
    assert user_move_cell_done = 1

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

    # O(N) finding max
    local q_max_0 = q_a_0

    let (local bool_le_1) = is_le(q_max_0, q_a_1)
    local q_max_1 = bool_le_1 * q_a_1 + (1-bool_le_1) * q_max_0

    let (local bool_le_2) = is_le(q_max_1, q_a_2)
    local q_max_2 = bool_le_2 * q_a_2 + (1-bool_le_2) * q_max_1

    #let (local bool_le_3) = is_le(q_max, q_a_3)
    #tempvar q_max = bool_le_3 * q_a_3 + (1-bool_le_3) * q_max

    #let (local bool_le_4) = is_le(q_max, q_a_4)
    #tempvar q_max = bool_le_4 * q_a_4 + (1-bool_le_4) * q_max

    #let (local bool_le_5) = is_le(q_max, q_a_5)
    #tempvar q_max = bool_le_5 * q_a_5 + (1-bool_le_5) * q_max

    #let (local bool_le_6) = is_le(q_max, q_a_6)
    #tempvar q_max = bool_le_6 * q_a_6 + (1-bool_le_6) * q_max

    #let (local bool_le_7) = is_le(q_max, q_a_7)
    #tempvar q_max = bool_le_7 * q_a_7 + (1-bool_le_7) * q_max

    #let (local bool_le_8) = is_le(q_max, q_a_8)
    #tempvar q_max = bool_le_8 * q_a_8 + (1-bool_le_8) * q_max

    # 5. decode AI's encoded action into AI move
    # TODO
    #tempvar x_ai = 2
    #tempvar y_ai = 2

    # 6. update board with AI move (AI is 2)
    #let (ai_move_cell) = board.read(x_ai, y_ai)
    #assert ai_move_cell = 0
    #board.write(x_ai, y_ai, 2)
    #let (ai_move_cell_done) = board.read(x_ai, y_ai)
    #assert ai_move_cell_done = 2

    # 7. return AI move
    #return (x_ai, y_ai)
    return (q_a_0, q_a_1, q_a_2, q_a_3, q_a_4, q_a_5, q_a_6, q_a_7, q_a_8, q_max_2)
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

    let (bool_a_0) = is_zero(a-0)
    let (bool_a_1) = is_zero(a-1)
    let (bool_a_2) = is_zero(a-2)
    let (bool_a_3) = is_zero(a-3)
    let (bool_a_4) = is_zero(a-4)
    let (bool_a_5) = is_zero(a-5)
    let (bool_a_6) = is_zero(a-6)
    let (bool_a_7) = is_zero(a-7)
    let (bool_a_8) = is_zero(a-8)

    let (bool_s_0) = is_zero(s-0)
    let (bool_s_162) = is_zero(s-162)
    let (bool_s_6723) = is_zero(s-6723)
    let (bool_s_7218) = is_zero(s-7218)
    let (bool_s_189) = is_zero(s-189)
    let (bool_s_486) = is_zero(s-486)
    let (bool_s_2835) = is_zero(s-2835)
    let (bool_s_4320) = is_zero(s-4320)
    let (bool_s_909) = is_zero(s-909)
    let (bool_s_16218) = is_zero(s-16218)
    let (bool_s_249) = is_zero(s-249)
    let (bool_s_15558) = is_zero(s-15558)
    let (bool_s_15747) = is_zero(s-15747)
    let (bool_s_1656) = is_zero(s-1656)
    let (bool_s_891) = is_zero(s-891)
    let (bool_s_14022) = is_zero(s-14022)
    let (bool_s_171) = is_zero(s-171)
    let (bool_s_3834) = is_zero(s-3834)
    let (bool_s_11106) = is_zero(s-11106)
    let (bool_s_165) = is_zero(s-165)
    let (bool_s_16200) = is_zero(s-16200)
    let (bool_s_1458) = is_zero(s-1458)
    let (bool_s_1629) = is_zero(s-1629)
    let (bool_s_8676) = is_zero(s-8676)
    let (bool_s_912) = is_zero(s-912)
    let (bool_s_11847) = is_zero(s-11847)
    let (bool_s_1632) = is_zero(s-1632)
    let (bool_s_405) = is_zero(s-405)
    let (bool_s_13536) = is_zero(s-13536)
    let (bool_s_8703) = is_zero(s-8703)
    let (bool_s_10368) = is_zero(s-10368)
    let (bool_s_14994) = is_zero(s-14994)
    let (bool_s_2349) = is_zero(s-2349)
    let (bool_s_11826) = is_zero(s-11826)
    let (bool_s_3822) = is_zero(s-3822)
    let (bool_s_54) = is_zero(s-54)
    let (bool_s_6777) = is_zero(s-6777)
    let (bool_s_3816) = is_zero(s-3816)
    let (bool_s_10887) = is_zero(s-10887)
    let (bool_s_1152) = is_zero(s-1152)
    let (bool_s_16461) = is_zero(s-16461)
    let (bool_s_10935) = is_zero(s-10935)
    let (bool_s_15498) = is_zero(s-15498)
    let (bool_s_17199) = is_zero(s-17199)
    let (bool_s_6) = is_zero(s-6)
    let (bool_s_2355) = is_zero(s-2355)
    let (bool_s_5274) = is_zero(s-5274)
    let (bool_s_426) = is_zero(s-426)
    let (bool_s_15714) = is_zero(s-15714)
    let (bool_s_7209) = is_zero(s-7209)
    let (bool_s_7047) = is_zero(s-7047)
    let (bool_s_10692) = is_zero(s-10692)
    let (bool_s_4545) = is_zero(s-4545)
    let (bool_s_16206) = is_zero(s-16206)
    let (bool_s_5265) = is_zero(s-5265)
    let (bool_s_1140) = is_zero(s-1140)
    let (bool_s_2844) = is_zero(s-2844)
    let (bool_s_495) = is_zero(s-495)
    let (bool_s_513) = is_zero(s-513)
    let (bool_s_7236) = is_zero(s-7236)
    let (bool_s_14013) = is_zero(s-14013)
    let (bool_s_17181) = is_zero(s-17181)
    let (bool_s_6729) = is_zero(s-6729)
    let (bool_s_10374) = is_zero(s-10374)
    let (bool_s_4563) = is_zero(s-4563)
    let (bool_s_11196) = is_zero(s-11196)
    let (bool_s_11361) = is_zero(s-11361)
    let (bool_s_219) = is_zero(s-219)
    let (bool_s_13584) = is_zero(s-13584)
    let (bool_s_18) = is_zero(s-18)
    let (bool_s_6741) = is_zero(s-6741)
    let (bool_s_4374) = is_zero(s-4374)
    let (bool_s_45) = is_zero(s-45)
    let (bool_s_612) = is_zero(s-612)
    let (bool_s_2862) = is_zero(s-2862)
    let (bool_s_4329) = is_zero(s-4329)
    let (bool_s_651) = is_zero(s-651)
    let (bool_s_4572) = is_zero(s-4572)
    let (bool_s_1650) = is_zero(s-1650)
    let (bool_s_16221) = is_zero(s-16221)
    let (bool_s_6984) = is_zero(s-6984)
    let (bool_s_12087) = is_zero(s-12087)
    let (bool_s_13122) = is_zero(s-13122)
    let (bool_s_15471) = is_zero(s-15471)
    let (bool_s_11844) = is_zero(s-11844)
    let (bool_s_14040) = is_zero(s-14040)
    let (bool_s_13287) = is_zero(s-13287)
    let (bool_s_2364) = is_zero(s-2364)
    let (bool_s_3153) = is_zero(s-3153)
    let (bool_s_16518) = is_zero(s-16518)
    let (bool_s_15) = is_zero(s-15)
    let (bool_s_204) = is_zero(s-204)
    let (bool_s_3849) = is_zero(s-3849)
    let (bool_s_15309) = is_zero(s-15309)
    let (bool_s_1623) = is_zero(s-1623)
    let (bool_s_1422) = is_zero(s-1422)
    let (bool_s_13311) = is_zero(s-13311)
    let (bool_s_12333) = is_zero(s-12333)
    let (bool_s_15021) = is_zero(s-15021)
    let (bool_s_13293) = is_zero(s-13293)
    let (bool_s_11340) = is_zero(s-11340)
    let (bool_s_225) = is_zero(s-225)
    let (bool_s_2403) = is_zero(s-2403)
    let (bool_s_897) = is_zero(s-897)
    let (bool_s_8196) = is_zero(s-8196)
    let (bool_s_657) = is_zero(s-657)
    let (bool_s_6579) = is_zero(s-6579)
    let (bool_s_3096) = is_zero(s-3096)
    let (bool_s_8019) = is_zero(s-8019)
    let (bool_s_8184) = is_zero(s-8184)
    let (bool_s_13080) = is_zero(s-13080)
    let (bool_s_1398) = is_zero(s-1398)
    let (bool_s_15480) = is_zero(s-15480)
    let (bool_s_15537) = is_zero(s-15537)
    let (bool_s_10863) = is_zero(s-10863)
    let (bool_s_14061) = is_zero(s-14061)
    let (bool_s_11619) = is_zero(s-11619)
    let (bool_s_7959) = is_zero(s-7959)
    let (bool_s_675) = is_zero(s-675)
    let (bool_s_183) = is_zero(s-183)
    let (bool_s_1662) = is_zero(s-1662)
    let (bool_s_7524) = is_zero(s-7524)
    let (bool_s_4539) = is_zero(s-4539)
    let (bool_s_3690) = is_zero(s-3690)
    let (bool_s_13365) = is_zero(s-13365)
    let (bool_s_13554) = is_zero(s-13554)
    let (bool_s_4617) = is_zero(s-4617)
    let (bool_s_5508) = is_zero(s-5508)
    let (bool_s_5529) = is_zero(s-5529)
    let (bool_s_5286) = is_zero(s-5286)
    let (bool_s_297) = is_zero(s-297)
    let (bool_s_3807) = is_zero(s-3807)
    let (bool_s_87) = is_zero(s-87)
    let (bool_s_384) = is_zero(s-384)
    let (bool_s_11097) = is_zero(s-11097)
    let (bool_s_1467) = is_zero(s-1467)
    let (bool_s_4383) = is_zero(s-4383)
    let (bool_s_3810) = is_zero(s-3810)
    let (bool_s_177) = is_zero(s-177)
    let (bool_s_1188) = is_zero(s-1188)
    let (bool_s_7767) = is_zero(s-7767)
    let (bool_s_783) = is_zero(s-783)
    let (bool_s_882) = is_zero(s-882)
    let (bool_s_5103) = is_zero(s-5103)
    let (bool_s_1539) = is_zero(s-1539)
    let (bool_s_2052) = is_zero(s-2052)
    let (bool_s_6429) = is_zero(s-6429)
    let (bool_s_423) = is_zero(s-423)
    let (bool_s_13527) = is_zero(s-13527)
    let (bool_s_4806) = is_zero(s-4806)
    let (bool_s_8181) = is_zero(s-8181)
    let (bool_s_954) = is_zero(s-954)
    let (bool_s_1215) = is_zero(s-1215)
    let (bool_s_1314) = is_zero(s-1314)
    let (bool_s_12558) = is_zero(s-12558)
    let (bool_s_966) = is_zero(s-966)
    let (bool_s_411) = is_zero(s-411)
    let (bool_s_207) = is_zero(s-207)
    let (bool_s_195) = is_zero(s-195)
    let (bool_s_3840) = is_zero(s-3840)
    let (bool_s_1386) = is_zero(s-1386)
    let (bool_s_906) = is_zero(s-906)
    let (bool_s_14319) = is_zero(s-14319)
    let (bool_s_17748) = is_zero(s-17748)
    let (bool_s_13380) = is_zero(s-13380)
    let (bool_s_14919) = is_zero(s-14919)
    let (bool_s_8514) = is_zero(s-8514)
    let (bool_s_420) = is_zero(s-420)
    let (bool_s_3132) = is_zero(s-3132)
    let (bool_s_63) = is_zero(s-63)
    let (bool_s_945) = is_zero(s-945)
    let (bool_s_7470) = is_zero(s-7470)
    let (bool_s_5571) = is_zero(s-5571)
    let (bool_s_7110) = is_zero(s-7110)
    let (bool_s_15720) = is_zero(s-15720)
    let (bool_s_17214) = is_zero(s-17214)
    let (bool_s_14535) = is_zero(s-14535)
    let (bool_s_13428) = is_zero(s-13428)
    let (bool_s_2034) = is_zero(s-2034)
    let (bool_s_459) = is_zero(s-459)
    let (bool_s_15768) = is_zero(s-15768)
    let (bool_s_4896) = is_zero(s-4896)
    let (bool_s_1602) = is_zero(s-1602)
    let (bool_s_2880) = is_zero(s-2880)
    let (bool_s_3651) = is_zero(s-3651)
    let (bool_s_10869) = is_zero(s-10869)
    let (bool_s_13131) = is_zero(s-13131)
    let (bool_s_14670) = is_zero(s-14670)
    let (bool_s_4752) = is_zero(s-4752)
    let (bool_s_2412) = is_zero(s-2412)
    let (bool_s_15777) = is_zero(s-15777)
    let (bool_s_1377) = is_zero(s-1377)
    let (bool_s_18423) = is_zero(s-18423)
    let (bool_s_1647) = is_zero(s-1647)
    let (bool_s_16263) = is_zero(s-16263)
    let (bool_s_210) = is_zero(s-210)
    let (bool_s_2193) = is_zero(s-2193)
    let (bool_s_16044) = is_zero(s-16044)
    let (bool_s_1206) = is_zero(s-1206)
    let (bool_s_12141) = is_zero(s-12141)
    let (bool_s_735) = is_zero(s-735)
    let (bool_s_747) = is_zero(s-747)
    let (bool_s_13851) = is_zero(s-13851)
    let (bool_s_948) = is_zero(s-948)
    let (bool_s_16215) = is_zero(s-16215)
    let (bool_s_1158) = is_zero(s-1158)
    let (bool_s_7458) = is_zero(s-7458)
    let (bool_s_14055) = is_zero(s-14055)
    let (bool_s_57) = is_zero(s-57)
    let (bool_s_4512) = is_zero(s-4512)
    let (bool_s_6213) = is_zero(s-6213)
    let (bool_s_5763) = is_zero(s-5763)
    let (bool_s_11718) = is_zero(s-11718)
    let (bool_s_11889) = is_zero(s-11889)
    let (bool_s_1203) = is_zero(s-1203)
    let (bool_s_13320) = is_zero(s-13320)
    let (bool_s_17910) = is_zero(s-17910)
    let (bool_s_2367) = is_zero(s-2367)
    let (bool_s_6567) = is_zero(s-6567)
    let (bool_s_6615) = is_zero(s-6615)
    let (bool_s_11883) = is_zero(s-11883)
    let (bool_s_12144) = is_zero(s-12144)
    let (bool_s_7182) = is_zero(s-7182)
    let (bool_s_3147) = is_zero(s-3147)
    let (bool_s_1872) = is_zero(s-1872)
    let (bool_s_2142) = is_zero(s-2142)
    let (bool_s_5922) = is_zero(s-5922)
    let (bool_s_7062) = is_zero(s-7062)
    let (bool_s_7953) = is_zero(s-7953)
    let (bool_s_6768) = is_zero(s-6768)
    let (bool_s_5787) = is_zero(s-5787)
    let (bool_s_13590) = is_zero(s-13590)
    let (bool_s_6876) = is_zero(s-6876)
    let (bool_s_10521) = is_zero(s-10521)
    let (bool_s_8190) = is_zero(s-8190)
    let (bool_s_5118) = is_zero(s-5118)
    let (bool_s_11682) = is_zero(s-11682)
    let (bool_s_11385) = is_zero(s-11385)
    let (bool_s_6780) = is_zero(s-6780)
    let (bool_s_684) = is_zero(s-684)
    let (bool_s_5052) = is_zero(s-5052)
    let (bool_s_4680) = is_zero(s-4680)
    let (bool_s_7476) = is_zero(s-7476)
    let (bool_s_14262) = is_zero(s-14262)
    let (bool_s_789) = is_zero(s-789)
    let (bool_s_1194) = is_zero(s-1194)
    let (bool_s_12150) = is_zero(s-12150)
    let (bool_s_1419) = is_zero(s-1419)
    let (bool_s_14034) = is_zero(s-14034)
    let (bool_s_14271) = is_zero(s-14271)
    let (bool_s_5268) = is_zero(s-5268)
    let (bool_s_4779) = is_zero(s-4779)
    let (bool_s_13884) = is_zero(s-13884)
    let (bool_s_1863) = is_zero(s-1863)
    let (bool_s_4800) = is_zero(s-4800)
    let (bool_s_18399) = is_zero(s-18399)
    let (bool_s_15729) = is_zero(s-15729)
    let (bool_s_10998) = is_zero(s-10998)
    let (bool_s_10896) = is_zero(s-10896)
    let (bool_s_14016) = is_zero(s-14016)
    let (bool_s_6702) = is_zero(s-6702)
    let (bool_s_11430) = is_zero(s-11430)
    let (bool_s_13077) = is_zero(s-13077)
    let (bool_s_11124) = is_zero(s-11124)
    let (bool_s_6030) = is_zero(s-6030)
    let (bool_s_13560) = is_zero(s-13560)
    let (bool_s_6744) = is_zero(s-6744)
    let (bool_s_3645) = is_zero(s-3645)
    let (bool_s_4050) = is_zero(s-4050)
    let (bool_s_7041) = is_zero(s-7041)
    let (bool_s_105) = is_zero(s-105)
    let (bool_s_21) = is_zero(s-21)
    let (bool_s_14256) = is_zero(s-14256)
    let (bool_s_1380) = is_zero(s-1380)
    let (bool_s_7038) = is_zero(s-7038)
    let (bool_s_531) = is_zero(s-531)
    let (bool_s_2418) = is_zero(s-2418)
    let (bool_s_15783) = is_zero(s-15783)
    let (bool_s_5292) = is_zero(s-5292)
    let (bool_s_11610) = is_zero(s-11610)
    let (bool_s_1515) = is_zero(s-1515)
    let (bool_s_5835) = is_zero(s-5835)
    let (bool_s_5121) = is_zero(s-5121)
    let (bool_s_13149) = is_zero(s-13149)
    let (bool_s_480) = is_zero(s-480)
    let (bool_s_0) = is_zero(s-0)
    let (bool_s_83) = is_zero(s-83)
    let (bool_s_8102) = is_zero(s-8102)
    let (bool_s_162) = is_zero(s-162)
    let (bool_s_2351) = is_zero(s-2351)
    return (q = 0)
end