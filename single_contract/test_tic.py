import pytest
from starkware.starknet.testing.starknet import Starknet
from timeit import default_timer as timer

# Utility function to read board status from contract and print in pretty form
def read_and_print_board(board):
    for row in range(3):
        for col in range(3):
            print(board[3*row + col], end=' ')
        print()
    print()

@pytest.mark.asyncio
async def test_tic():
    print()

    starknet = await Starknet.empty()
    contract = await starknet.deploy("tic.cairo")

    status_dict = {
        0 : 'ongoing',
        1 : 'ai win',
        2 : 'user win',
        3 : 'draw'
    }

    # board initialization
    await contract.test_configure_board(1,1,2).invoke() # user is 2
    await contract.test_configure_board(2,2,1).invoke() # AI is 1

    print("> board after initial configuration:")
    board = [0,0,0,0,0,0,0,0,0]
    (
        board[0], board[1], board[2],
        board[3], board[4], board[5],
        board[6], board[7], board[8]
    ) = await contract.view_board().call()
    read_and_print_board(board)

    ret = await contract.check_game_status().call()
    print(f"> game status: {status_dict[ret.status]}")
    print()

    # Round 1
    print("> Round 1")
    row_user = 0
    col_user = 2
    ret_user_move = await contract.user_move(row_user=row_user, col_user=col_user).invoke()

    print(f"> user_move(row_user={row_user}, col_user={col_user}) returns: {ret_user_move}")
    print("> board after user_move and AI's countermove:")
    board = [0,0,0,0,0,0,0,0,0]
    (
        board[0], board[1], board[2],
        board[3], board[4], board[5],
        board[6], board[7], board[8]
    ) = await contract.view_board().call()
    read_and_print_board(board)

    ret = await contract.check_game_status().call()
    print(f"> game status: {status_dict[ret.status]}")
    print()

    # Round 2
    print("> Round 2")
    row_user = 0
    col_user = 1
    ret_user_move = await contract.user_move(row_user=row_user, col_user=col_user).invoke()

    print(f"> user_move(row_user={row_user}, col_user={col_user}) returns: {ret_user_move}")
    print("> board after user_move and AI's countermove:")
    board = [0,0,0,0,0,0,0,0,0]
    (
        board[0], board[1], board[2],
        board[3], board[4], board[5],
        board[6], board[7], board[8]
    ) = await contract.view_board().call()
    read_and_print_board(board)

    ret = await contract.check_game_status().call()
    print(f"> game status: {status_dict[ret.status]}")