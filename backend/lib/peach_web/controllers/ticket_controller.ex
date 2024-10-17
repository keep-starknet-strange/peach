defmodule PeachWeb.TicketController do
  use PeachWeb, :controller
  alias Peach.Tickets

  def index(conn, %{"address" => address}) do
    # Fetch the tickets with preloaded ticket_tier and event associations
    tickets = Tickets.list_tickets_with_event_by_owner(address)

    # Group tickets by event and then by tier_id within each event
    events_with_tickets =
      tickets
      |> Enum.group_by(& &1.ticket_tier.event)
      |> Enum.map(fn {event, tickets} ->
        # Group tickets by tier within each event
        tickets_by_tier =
          tickets
          |> Enum.group_by(fn ticket -> ticket.ticket_tier end)
          |> Enum.map(fn {tier, tickets} ->
            %{
              "tier_id" => tier.id,
              "name" => tier.name,
              "description" => tier.description,
              "ticket_ids" => Enum.map(tickets, & &1.id) |> Enum.sort()
            }
          end)

        %{
          "name" => event.name,
          "location" => event.location,
          "start" => event.start,
          "end" => event.end,
          "cover" => event.cover,
          "tickets" => tickets_by_tier
        }
      end)

    # Wrap the result in a top-level map with "events" key
    json(conn, %{events: events_with_tickets})
  end
end
