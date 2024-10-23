defmodule Starknet do
  use Rustler, otp_app: :peach, crate: "starknet"

  # Fallback function in case the NIF is not loaded
  def execute_tx(_provider_url, _private_key, _address, _chain_id, _calls),
    do: :erlang.nif_error(:nif_not_loaded)
end
