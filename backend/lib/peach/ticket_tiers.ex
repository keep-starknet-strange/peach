defmodule Peach.TicketTiers do
  @moduledoc """
  Manages the events for the peach app
  """
  alias Peach.TicketTier
  alias Peach.Repo

  import Ecto.Query

  def event_ticket_tiers(event_id),
    do: Repo.all(from tt in TicketTier, where: tt.event_id == ^event_id)
end
