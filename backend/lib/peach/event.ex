defmodule Peach.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder
  schema "events" do
    field :name, :string
    field :date, :naive_datetime
    field :description, :string
    field :location, :string
    field :cover, :string
    field :onchain, :boolean, default: false

    has_many :ticket_tiers, Peach.TicketTier

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :description, :location, :date, :cover])
    |> cast_assoc(:ticket_tiers, with: &Peach.TicketTier.changeset/2)
    |> validate_required([:name, :description, :location, :date, :cover])
  end
end
