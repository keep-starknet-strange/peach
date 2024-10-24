defmodule PeachWeb.TicketTierControllerTest do
  use PeachWeb.ConnCase, async: true
  alias Peach.{Event, Repo, Ticket, TicketTier}

  setup do
    # Insert a sample event and ticket tiers for testing
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
        price: 10,
        event_id: event.id
      })

    standard_tier =
      Repo.insert!(%TicketTier{
        name: "Standard",
        description: "General admission",
        max_supply: 200,
        price: 5,
        event_id: event.id
      })

    # Create a few tickets associated with this tier
    _ticket1 = Repo.insert!(%Ticket{ticket_tier_id: vip_tier.id})
    # Pass event and ticket tiers to each test case
    _ticket2 = Repo.insert!(%Ticket{ticket_tier_id: vip_tier.id})
    {:ok, event: event, vip_tier: vip_tier, standard_tier: standard_tier}
  end

  test "returns ticket tiers for a valid event_id", %{
    conn: conn,
    event: event,
    vip_tier: vip_tier,
    standard_tier: standard_tier
  } do
    # Send the GET request with a valid event_id
    conn = get(conn, "/api/events/#{event.id}/ticket_tiers")

    # Expected response structure
    expected_response = %{
      "ticket_tiers" => [
        %{
          "id" => vip_tier.id,
          "name" => vip_tier.name,
          "description" => vip_tier.description,
          "price" => vip_tier.price,
          "max_supply" => vip_tier.max_supply
        },
        %{
          "id" => standard_tier.id,
          "name" => standard_tier.name,
          "description" => standard_tier.description,
          "price" => standard_tier.price,
          "max_supply" => standard_tier.max_supply
        }
      ]
    }

    # Assert the response status and structure
    assert json_response(conn, 200) == expected_response
  end

  test "returns error for invalid event_id", %{conn: conn} do
    # Send the GET request with an invalid event_id
    conn = get(conn, "/api/events/9999/ticket_tiers")

    # Assert the response status and error message
    assert json_response(conn, 200) == %{"ticket_tiers" => []}
  end

  test "returns ticket tier with remaining tickets for valid id", %{
    conn: conn,
    vip_tier: ticket_tier
  } do
    # Call the show endpoint with a valid ticket_tier_id
    conn = get(conn, "/api/ticket_tiers/#{ticket_tier.id}")

    # Expected response
    expected_response = %{
      "ticket_tier" => %{
        "id" => ticket_tier.id,
        "name" => ticket_tier.name,
        "description" => ticket_tier.description,
        "max_supply" => ticket_tier.max_supply,
        "price" => ticket_tier.price,
        # Expected remaining tickets (50 - 2 tickets sold)
        "remaining" => 48
      }
    }

    # Assert that the response status is 200 and matches the expected response
    assert json_response(conn, 200) == expected_response
  end

  test "returns error for invalid ticket_tier_id", %{conn: conn} do
    # Call the show endpoint with an invalid ticket_tier_id
    conn = get(conn, "/api/ticket_tiers/9999")

    # Expected error response (adjust based on your actual error handling)
    expected_error = %{"errors" => "Ticket tier not found"}

    # Assert the response status and error message
    assert json_response(conn, 404) == expected_error
  end
end
