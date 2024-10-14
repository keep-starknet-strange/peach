defmodule PeachWeb.TicketControllerTest do
  use PeachWeb.ConnCase, async: true
  alias Peach.{Event, Repo, Ticket, TicketTier}

  setup do
    # Create an event
    event =
      Repo.insert!(%Event{
        name: "Blockchain Conference",
        date: ~N[2024-11-10 00:00:00],
        description: "A blockchain event",
        location: "San Francisco, CA",
        cover: "https://example.com/cover.jpg",
        treasury: "0x1234567890abcdef1234567890abcdef12345678"
      })

    # Create ticket tiers associated with the event
    vip_tier =
      Repo.insert!(%TicketTier{
        name: "VIP",
        description: "Access to VIP sessions",
        max_supply: 100,
        event_id: event.id
      })

    standard_tier =
      Repo.insert!(%TicketTier{
        name: "Standard",
        description: "General admission",
        max_supply: 200,
        event_id: event.id
      })

    # Create tickets for the user address associated with the tiers
    vip_ticket =
      Repo.insert!(%Ticket{
        owner: "0xdead",
        # Using tier_id from the association
        ticket_tier_id: vip_tier.id
      })

    # Create tickets for the user address associated with the tiers
    vip_ticket =
      Repo.insert!(%Ticket{
        owner: "0xdead",
        # Using tier_id from the association
        ticket_tier_id: vip_tier.id
      })

    standard_ticket =
      Repo.insert!(%Ticket{
        owner: "0xdead",
        ticket_tier_id: standard_tier.id
      })

    standard_ticket =
      Repo.insert!(%Ticket{
        owner: "0xdead2",
        ticket_tier_id: standard_tier.id
      })

    # Make the created data available for all tests
    {:ok, event: event, vip_ticket: vip_ticket, standard_ticket: standard_ticket}
  end

  test "returns events with tickets grouped by event for a given owner", %{
    conn: conn,
    vip_ticket: vip_ticket,
    standard_ticket: standard_ticket
  } do
    # Send the GET request to the endpoint
    conn = get(conn, "/api/tickets/0xdead")

    # Expected JSON structure
    expected_response = %{
      "events" => [
        %{
          "name" => "Blockchain Conference",
          "location" => "San Francisco, CA",
          "date" => "2024-11-10T00:00:00",
          "cover" => "https://example.com/cover.jpg",
          "tickets" => [
            %{
              "tier_id" => vip_ticket.ticket_tier_id,
              "name" => "VIP",
              "description" => "Access to VIP sessions",
              "ticket_ids" => [1, 2]
            },
            %{
              "tier_id" => standard_ticket.ticket_tier_id,
              "name" => "Standard",
              "description" => "General admission",
              "ticket_ids" => [3]
            }
          ]
        }
      ]
    }

    # Assert that the response matches the expected JSON structure
    assert json_response(conn, 200) == expected_response
  end

  test "returns an empty events list if no tickets are found for the address", %{conn: conn} do
    # Send the GET request to the endpoint with an address that has no tickets
    conn = get(conn, "/api/tickets/0xnonexistentaddress")

    # Assert that the response is an empty list under "events"
    assert json_response(conn, 200) == %{"events" => []}
  end
end
