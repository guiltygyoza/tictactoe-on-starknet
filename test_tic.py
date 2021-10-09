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

    z_s = {}
    for y in range(3):
        for x in range(3):
            ret = await contract.view_board(x=x, y=y).call()
            z_s[(x,y)] = ret.z
            #print(f'{ret.z}', end=' ')
        #print()

    time3 = timer()

    print(f"> user_move(x={x}, y={y}) returns: {ret_user_move}")
    for y in range(3):
        for x in range(3):
            print(f'{z_s[(x,y)]}', end=' ')
        print()

    print(f"> time2-time1: {time2 - time1} sec")
    print(f"> time3-time2: {time3 - time2} sec")
