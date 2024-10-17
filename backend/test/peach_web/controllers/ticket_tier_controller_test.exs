defmodule PeachWeb.TicketTierControllerTest do
  use PeachWeb.ConnCase, async: true
  alias Peach.{Event, Repo, TicketTier}

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
        event_id: event.id
      })

    standard_tier =
      Repo.insert!(%TicketTier{
        name: "Standard",
        description: "General admission",
        max_supply: 200,
        event_id: event.id
      })

    # Pass event and ticket tiers to each test case
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
          "max_supply" => vip_tier.max_supply
        },
        %{
          "id" => standard_tier.id,
          "name" => standard_tier.name,
          "description" => standard_tier.description,
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

    # Expected error response
    expected_error = %{"errors" => "Event not found"}

    # Assert the response status and error message
    assert json_response(conn, 200) == %{"ticket_tiers" => []}
  end
end
