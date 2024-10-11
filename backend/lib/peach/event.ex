defmodule Peach.Event do
  @moduledoc """
  Defines an event object for the peach app
  """
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
    field :treasury, :string

    has_many :ticket_tiers, Peach.TicketTier

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :description, :location, :date, :cover, :treasury])
    |> cast_assoc(:ticket_tiers, with: &Peach.TicketTier.changeset/2, required: true)
    |> validate_required([:name, :description, :location, :date, :cover, :treasury])
    |> validate_format(:treasury, ~r/^0x[0-9a-fA-F]{1,64}$/)
  end

  def update_changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :description, :location, :date, :cover, :treasury])
    |> validate_required([:name, :description, :location, :date, :cover, :treasury])
    |> validate_format(:treasury, ~r/^0x[0-9a-fA-F]{1,64}$/)
  end
end
