import pytest
from starkware.starknet.testing.starknet import Starknet
from timeit import default_timer as timer

@pytest.mark.asyncio
async def test_tic():
    starknet = await Starknet.empty()
    contract = await starknet.deploy("tic.cairo")

    #ret = await contract.toy_lookup(
    #    x=10, y=100).call()
    #print(f"> toy_lookup(x=10, y=100) returns: {ret}")

    x=2
    y=2

    time1 = timer()

    ret_user_move = await contract.user_move(x=x, y=y).invoke()

    time2 = timer()

    board = [0,0,0,0,0,0,0,0,0]
    (
        board[0], board[1], board[2],
        board[3], board[4], board[5],
        board[6], board[7], board[8]
    ) = await contract.view_board().call()

    time3 = timer()

    await contract.reset_board().invoke()

    time4 = timer()

    board_0 = [0,0,0,0,0,0,0,0,0]
    (
        board_0[0], board_0[1], board_0[2],
        board_0[3], board_0[4], board_0[5],
        board_0[6], board_0[7], board_0[8]
    ) = await contract.view_board().call()

    print(f"> user_move(x={x}, y={y}) returns: {ret_user_move}")

    print("board after user_move and AI's countermove:")
    for y in range(3):
        for x in range(3):
            print(board[3*y + x], end=' ')
        print()

    print()

    print("board after reset_board():")
    for y in range(3):
        for x in range(3):
            print(board_0[3*y + x], end=' ')
        print()

    print(f"> time2-time1: {time2 - time1} sec")
    print(f"> time3-time2: {time3 - time2} sec")
    print(f"> time4-time3: {time4 - time3} sec")
