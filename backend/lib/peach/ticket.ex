defmodule Peach.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :owner, :string
    field :balance, :integer
    field :tier_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:owner, :balance, :tier_id])
    |> validate_required([:owner, :balance, :tier_id])
    |> validate_length(:owner, max: 66)
  end
end
