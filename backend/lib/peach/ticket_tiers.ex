defmodule Peach.TicketTiers do
  @moduledoc """
  Manages the events for the peach app
  """
  alias Peach.Repo
  alias Peach.{Ticket, TicketTier}
  import Ecto.Query

  def event_ticket_tiers(event_id),
    do: Repo.all(from tt in TicketTier, where: tt.event_id == ^event_id)

  def remaining_tickets(ticket_tier_id) do
    case Repo.get(TicketTier, ticket_tier_id) do
      nil ->
        {:error, "Ticket tier not found"}

      ticket_tier ->
        sold_tickets =
          Repo.one(
            from(t in Ticket,
              where: t.ticket_tier_id == ^ticket_tier_id,
              select: count(t.id)
            )
          )

        {:ok,
         %{
           id: ticket_tier.id,
           name: ticket_tier.name,
           description: ticket_tier.description,
           remaining: ticket_tier.max_supply - sold_tickets,
           max_supply: ticket_tier.max_supply
         }}
    end
  end
end
