defmodule Peach.TicketTier do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder
  schema "ticket_tiers" do
    field :name, :string
    field :description, :string
    field :max_supply, :integer

    belongs_to :event, Peach.Event

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket_tier, attrs) do
    ticket_tier
    |> cast(attrs, [:name, :description, :max_supply])
    |> validate_required([:name, :description, :max_supply])
  end
end
