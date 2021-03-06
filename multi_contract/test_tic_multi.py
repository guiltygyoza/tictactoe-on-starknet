import pytest
from starkware.starknet.testing.starknet import Starknet
from timeit import default_timer as timer

@pytest.mark.asyncio
async def test_tic():
    print()

    starknet = await Starknet.empty()
    contract_main = await starknet.deploy("tic_multi.cairo")
    print('> Deployed: contract_main.')

    contract_computes = []
    for i in range(11):
        contract_compute = await starknet.deploy(f"tic_compute_generated_{i}.cairo")
        print(f'> Deployed: contract_compute[{i}].')

        await contract_main.store_contract_compute_addresses(
            key=i, value=contract_compute.contract_address
        ).invoke()
        print(f"> Stored contract_compute[{i}]'s address to contract_main.")

        contract_computes.append(contract_compute)

    # board initialization
    #await contract.test_configure_board(1,1,2).invoke() # user is 2
    #await contract.test_configure_board(2,2,1).invoke() # AI is 1

    board_0 = [0,0,0,0,0,0,0,0,0]
    (
        board_0[0], board_0[1], board_0[2],
        board_0[3], board_0[4], board_0[5],
        board_0[6], board_0[7], board_0[8]
    ) = await contract_main.view_board().call()

    print("> board after initial configuration:")
    for y in range(3):
        for x in range(3):
            print(board_0[3*y + x], end=' ')
        print()
    print()

    # user_move
    x=1
    y=1

    time1 = timer()
    ret_user_move = await contract_main.user_move(x=x, y=y).invoke()
    time2 = timer()

    board = [0,0,0,0,0,0,0,0,0]
    (
        board[0], board[1], board[2],
        board[3], board[4], board[5],
        board[6], board[7], board[8]
    ) = await contract_main.view_board().call()
    time3 = timer()

    await contract_main.reset_board().invoke()
    time4 = timer()

    # print results
    print(f"> user_move(x={x}, y={y}) returns: {ret_user_move}")

    print("> board after user_move and AI's countermove:")
    for y in range(3):
        for x in range(3):
            print(board[3*y + x], end=' ')
        print()
    print()

    print(f"> time2-time1: {time2 - time1} sec (user_move)")
    print(f"> time3-time2: {time3 - time2} sec (view_board)")
    print(f"> time4-time3: {time4 - time3} sec (reset_board)")
