import pytest
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test_tic():
    starknet = await Starknet.empty()
    contract = await starknet.deploy("tic.cairo")

    ret = await contract.toy_lookup(
        x=10, y=100).invoke()

    print(f"> toy_lookup(x=10, y=100) returns: {ret}")

    X = [1,2,3,4,5,6,7,8]
    Y = [4,5,6,7,8,9,1,2]

    for (x,y) in zip(X,Y):
        z = await contract.view_board(x=x, y=y).call()
        print(f"> view_board(x={x}, y={y}) returns: {z}")

    ret = await contract.user_move(x=1, y=1).invoke()
    print(f"> user_move(x=1, y=1) returns: {ret}")
