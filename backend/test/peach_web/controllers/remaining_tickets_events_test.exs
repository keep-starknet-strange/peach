defmodule PeachWeb.EventControllerTest do
  use PeachWeb.ConnCase, async: true
  alias Peach.{Event, Repo, Ticket, TicketTier}

  setup do
    event =
      Repo.insert!(%Event{
        name: "Sample Event",
        start: ~N[2024-11-10 09:00:00],
        end: ~N[2024-11-12 17:00:00]
      })

    vip_tier =
      Repo.insert!(%TicketTier{
        name: "VIP",
        description: "Access to VIP areas",
        max_supply: 50,
        event_id: event.id
      })

    standard_tier =
      Repo.insert!(%TicketTier{
        name: "Standard",
        description: "General admission",
        max_supply: 200,
        event_id: event.id
      })

    # Create a few tickets associated with this tier
    _ticket1 = Repo.insert!(%Ticket{ticket_tier_id: vip_tier.id})
    # Pass event and ticket tiers to each test case
    _ticket2 = Repo.insert!(%Ticket{ticket_tier_id: vip_tier.id})

    # Pass the event to each test case
    {:ok, event: event, vip_tier: vip_tier, standard_tier: standard_tier}
  end

  test "returns remaining tickets for a valid event id", %{
    conn: conn,
    vip_tier: vip_tier,
    standard_tier: standard_tier,
    event: event
  } do
    # Call the remaining_event_tickets endpoint with a valid event ID
    conn = get(conn, "/api/events/#{event.id}/remaining_tickets")

    expected_response = %{
      "tickets" => [
        %{
          "id" => vip_tier.id,
          "name" => vip_tier.name,
          "description" => vip_tier.description,
          "max_supply" => vip_tier.max_supply,
          "remaining" => 48
        },
        %{
          "id" => standard_tier.id,
          "name" => standard_tier.name,
          "description" => standard_tier.description,
          "max_supply" => standard_tier.max_supply,
          "remaining" => standard_tier.max_supply
        }
      ]
    }

    # Assert the response status and content
    assert json_response(conn, 200) == expected_response
  end

  test "returns error for an invalid event id", %{conn: conn} do
    # Call the remaining_event_tickets endpoint with an invalid event ID
    conn = get(conn, "/api/events/9999/remaining_tickets")

    # Assert the response status and error message
    assert json_response(conn, 404) == %{"errors" => "Event not found"}
  end
end
