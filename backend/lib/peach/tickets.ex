defmodule Peach.Tickets do
  @moduledoc """
  Manages the tickets for the peach app
  """
  alias Peach.Repo
  alias Peach.Ticket
  import Ecto.Query

  def list_tickets_with_event_by_owner(owner_address) do
    Repo.all(
      from t in Ticket,
        where: t.owner == ^owner_address,
        join: tier in assoc(t, :ticket_tier),
        join: event in assoc(tier, :event),
        preload: [ticket_tier: {tier, event: event}]
    )
  end
end
