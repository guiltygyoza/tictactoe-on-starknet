import pytest
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test_tic():
    starknet = await Starknet.empty()
    contract = await starknet.deploy("tic.cairo")

    ret = await contract.toy_lookup(
        x=10, y=100).call()
    print(f"> toy_lookup(x=10, y=100) returns: {ret}")

    ret = await contract.user_move(x=1, y=1).invoke()
    print(f"> user_move(x=1, y=1) returns: {ret}")
