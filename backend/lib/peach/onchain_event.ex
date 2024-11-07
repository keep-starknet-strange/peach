defmodule Peach.OnchainEvent do
  @moduledoc """
  Defines an onchain event object for the peach app
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:onchain, :event_id]}
  @primary_key {:id, :string, autogenerate: false}
  schema "onchain_events" do
    field :onchain, :boolean, default: false
    field :_cursor, :integer
    belongs_to :event, Peach.Event, foreign_key: :event_id
  end

  @doc false
  def changeset(onchain_event, attrs) do
    onchain_event
    |> cast(attrs, [:onchain])
    |> validate_required([:onchain])
  end
end
