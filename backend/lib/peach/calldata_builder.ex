defmodule Peach.CalldataBuilder do
  @moduledoc """
  Converts an Event struct into a calldata list for the smart contract.
  """

  import Bitwise

  def build_calldata(event) do
    # 1. Event ID as u64
    event_id = to_u64(event.id)

    # 2. Ticket Tiers
    ticket_tiers_params = build_ticket_tiers_params(event.ticket_tiers)

    # Combine all parts into the calldata list
    ["0x" <> Integer.to_string(event_id, 16)] ++
      Enum.map(ticket_tiers_params, &("0x" <> Integer.to_string(&1, 16))) ++
      [event.treasury]
  end

  defp to_u64(value) do
    value
    |> to_integer()
    |> check_integer_size(64)
  end

  defp build_ticket_tiers_params(ticket_tiers) do
    # Number of ticket tiers
    len = length(ticket_tiers)

    # Flattened list of ticket tier parameters
    tiers_params =
      ticket_tiers
      |> Enum.flat_map(&ticket_tier_to_params/1)

    [len] ++ tiers_params
  end

  defp ticket_tier_to_params(tier) do
    # Convert price to u256 (two u128)
    {price_low, price_high} = to_u256(tier.price)

    # Convert max_supply to u32
    max_supply = tier.max_supply |> to_integer() |> check_integer_size(32)

    [price_low, price_high, max_supply]
  end

  defp to_u256(value) do
    # Convert the value to a big integer
    bigint = to_integer(value)

    # Split into low and high 128 bits
    price_low = bigint &&& (1 <<< 128) - 1
    price_high = bigint >>> 128

    {price_low, price_high}
  end

  defp check_integer_size(value, bits) do
    max_value = (1 <<< bits) - 1

    if value < 0 or value > max_value do
      raise ArgumentError, "Value #{value} does not fit in #{bits} bits"
    else
      value
    end
  end

  defp to_integer(value) do
    cond do
      is_integer(value) ->
        value

      is_binary(value) ->
        try do
          String.to_integer(value)
        rescue
          ArgumentError ->
            reraise ArgumentError, "Cannot parse integer from string: #{value}"
        end

      true ->
        raise ArgumentError, "Cannot convert #{inspect(value)} to integer"
    end
  end
end
