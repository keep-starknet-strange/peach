defmodule StarknetTest do
  use ExUnit.Case
  doctest Starknet

  @moduletag :integration

  @private_key System.get_env("PRIVATE_KEY") ||
                 raise("PRIVATE_KEY environment variable is not set")
  @address System.get_env("ADDRESS") || raise("ADDRESS environment variable is not set")
  @provider_url System.get_env("PROVIDER_URL") ||
                  raise("PROVIDER_URL environment variable is not set")
  @chain_id "SN_SEPOLIA"
  setup_all do
    # Ensure the NIF is loaded
    Application.ensure_all_started(:starknet)
    :ok
  end

  test "execute_tx with valid parameters returns transaction hash" do
    calls = [
      {
        "0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7",
        "0x0083afd3f4caedc6eebf44246fe54e38c95e3179a5ec9ea81740eca5b482d12e",
        [@address, "0x01", "0x0"]
      }
    ]

    tx_hash = Starknet.execute_tx(@provider_url, @private_key, @address, @chain_id, calls)

    assert String.starts_with?(tx_hash, "0x")
  end

  test "execute_tx with invalid provider URL returns error" do
    provider_url = "invalid_url"
    calls = []

    result = Starknet.execute_tx(provider_url, @private_key, @address, @chain_id, calls)

    assert {:error, :invalid_provider_url} = result
  end

  test "execute_tx with invalid private key returns error" do
    private_key = "invalid_private_key"
    calls = []

    result = Starknet.execute_tx(@provider_url, private_key, @address, @chain_id, calls)

    assert {:error, :invalid_pk} = result
  end

  test "execute_tx with invalid address returns error" do
    address = "invalid_address"
    calls = []

    result = Starknet.execute_tx(@provider_url, @private_key, address, @chain_id, calls)

    assert {:error, :invalid_address} = result
  end

  test "execute_tx with invalid calls returns error" do
    calls = [
      {
        "invalid_contract_address",
        "0x01",
        ["0x01", "0x01"]
      }
    ]

    result = Starknet.execute_tx(@provider_url, @private_key, @address, @chain_id, calls)

    assert {:error, :invalid_to_address} = result
  end
end
