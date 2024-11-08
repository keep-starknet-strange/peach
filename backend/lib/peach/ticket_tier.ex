defmodule Peach.TicketTier do
  @moduledoc """
  Defines a ticket tier for the peach app
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :description, :max_supply, :price]}
  schema "ticket_tiers" do
    field :name, :string
    field :description, :string
    field :max_supply, :integer
    field :price, :integer

    belongs_to :event, Peach.Event

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket_tier, attrs) do
    ticket_tier
    |> cast(attrs, [:name, :description, :max_supply, :price])
    |> validate_required([:name, :description, :max_supply, :price])
  end
end
