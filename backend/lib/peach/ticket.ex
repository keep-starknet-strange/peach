defmodule Peach.Ticket do
  @moduledoc """
  Defines a ticket for the peach app
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :owner, :string

    belongs_to :ticket_tier, Peach.TicketTier

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:owner])
    |> validate_required([:owner])
    |> validate_format(:owner, ~r/^0x[0-9a-fA-F]{1,64}$/)
  end
end
