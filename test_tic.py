import pytest
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test_tic():
    starknet = await Starknet.empty()
    contract = await starknet.deploy("tic.cairo")

    #ret = await contract.toy_lookup(
    #    x=10, y=100).call()
    #print(f"> toy_lookup(x=10, y=100) returns: {ret}")

    x=2
    y=2
    ret = await contract.user_move(x=x, y=y).invoke()
    print(f"> user_move(x={x}, y={y}) returns: {ret}")

    #for y in range(3):
    #    for x in range(3):
    #        ret = await contract.view_board(x=x, y=y).call()
    #        print(f'{ret.z}', end=' ')
    #    print()
