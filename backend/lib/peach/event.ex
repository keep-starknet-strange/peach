defmodule Peach.Event do
  @moduledoc """
  Defines an event object for the peach app
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [:name, :description, :cover, :start, :end, :location, :treasury, :id]}
  schema "events" do
    field :name, :string
    field :start, :naive_datetime
    field :end, :naive_datetime
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
    |> cast(attrs, [:name, :description, :location, :start, :end, :cover, :treasury])
    |> cast_assoc(:ticket_tiers, with: &Peach.TicketTier.changeset/2, required: true)
    |> validate_required([:name, :description, :location, :start, :end, :cover, :treasury])
    |> validate_format(:treasury, ~r/^0x[0-9a-fA-F]{1,64}$/)
    |> validate_end_after_start()
  end

  def update_changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :description, :location, :start, :end, :cover, :treasury])
    |> validate_required([:name, :description, :location, :start, :end, :cover, :treasury])
    |> validate_format(:treasury, ~r/^0x[0-9a-fA-F]{1,64}$/)
    |> validate_end_after_start()
  end

  defp validate_end_after_start(changeset) do
    start_time = get_field(changeset, :start)
    end_time = get_field(changeset, :end)

    if start_time && end_time && NaiveDateTime.compare(end_time, start_time) != :gt do
      add_error(changeset, :end, "must be after the start date and time")
    else
      changeset
    end
  end
end
