defmodule Peach.Ticket do
  @moduledoc """
  Defines a ticket for the peach app
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  schema "tickets" do
    field :block_hash, :string
    field :block_number, :integer
    field :block_timestamp, :utc_datetime_usec
    field :transaction_hash, :string
    field :transfer_id, :string
    field :index_in_block, :integer
    field :owner, :string
    field :balance, :string
    field :created_at, :utc_datetime
    field :_cursor, :integer

    belongs_to :ticket_tier, Peach.TicketTier
    belongs_to :event, Peach.Event
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:owner])
    |> validate_required([:owner])
    |> validate_format(:owner, ~r/^0x[0-9a-fA-F]{1,64}$/)
  end
end
