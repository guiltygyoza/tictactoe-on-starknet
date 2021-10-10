%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.storage import Storage
from starkware.cairo.common.math import (
    unsigned_div_rem, assert_nn_le)
from starkware.cairo.common.math_cmp import (
    is_not_zero, is_le)

# utility function which wraps and inverts is_not_zero
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
    # z: 0 (empty), 1 (AI:O), 2 (USER:X); 0 by default automatically
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
        syscall_ptr : felt*,
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

    # Save the pointers to [fp]; otherwise revoked by is_le operations below
    local syscall_ptr : felt* = syscall_ptr
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

###############################################
####### PROGRAM FOR COMPUTE AGGREGATION #######
###############################################

@contract_interface
namespace IContractCompute:
    func compute(
        a : felt,
        s : felt
    ) -> (
        result : felt
    ):
    end
end

@storage_var
func contract_compute_addresses (key : felt) -> (value : felt):
end

@external
func store_contract_compute_addresses  {
        storage_ptr : Storage*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    } (
        key : felt,
        value : felt
    ):
    contract_compute_addresses.write(key, value)
    return ()
end

func q_lookup {
        syscall_ptr : felt*,
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

    ## the q_lookup operation is divided into cairo functions located in separate contracts.

    let (address_0) = contract_compute_addresses.read(key=0)
    let (local sop_0) = IContractCompute.compute(address_0, a, s)

    let (address_1) = contract_compute_addresses.read(key=1)
    let (local sop_1) = IContractCompute.compute(address_1, a, s)

    let (address_2) = contract_compute_addresses.read(key=2)
    let (local sop_2) = IContractCompute.compute(address_2, a, s)

    let (address_3) = contract_compute_addresses.read(key=3)
    let (local sop_3) = IContractCompute.compute(address_3, a, s)

    let (address_4) = contract_compute_addresses.read(key=4)
    let (local sop_4) = IContractCompute.compute(address_4, a, s)

    let (address_5) = contract_compute_addresses.read(key=5)
    let (local sop_5) = IContractCompute.compute(address_5, a, s)

    let (address_6) = contract_compute_addresses.read(key=6)
    let (local sop_6) = IContractCompute.compute(address_6, a, s)

    let (address_7) = contract_compute_addresses.read(key=7)
    let (local sop_7) = IContractCompute.compute(address_7, a, s)

    let (address_8) = contract_compute_addresses.read(key=8)
    let (local sop_8) = IContractCompute.compute(address_8, a, s)

    let (address_9) = contract_compute_addresses.read(key=9)
    let (local sop_9) = IContractCompute.compute(address_9, a, s)

    let (address_10) = contract_compute_addresses.read(key=10)
    let (local sop_10) = IContractCompute.compute(address_10, a, s)

    tempvar sop = sop_0 + sop_1 + sop_2 + sop_3 + sop_4 + sop_5 + sop_6 + sop_7 + sop_8 + sop_9 + sop_10
    return (sop)
end
