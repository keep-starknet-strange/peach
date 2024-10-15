defmodule PeachWeb.EventCreateControllerTest do
  use PeachWeb.ConnCase, async: true

  import Ecto.Query

  alias Peach.Event
  alias Peach.Repo
  alias Peach.TicketTier

  @valid_event_attrs %{
    "name" => "Blockchain Conference",
    "start" => "2024-11-10T10:00:00",
    "end" => "2024-11-10T13:00:00",
    "description" => "A conference about blockchain technology.",
    "location" => "San Francisco, CA",
    "cover" => "https://example.com/cover.jpg",
    "treasury" => "0xdead",
    "ticket_tiers" => [
      %{
        "name" => "General Admission",
        "description" => "Access to all sessions",
        "max_supply" => 100
      },
      %{
        "name" => "VIP",
        "description" => "Access to VIP sessions and perks",
        "max_supply" => 20
      }
    ]
  }

  test "creates an event with ticket tiers", %{conn: conn} do
    conn = post(conn, "/api/events/create", %{"event" => @valid_event_attrs})

    # Assert response status
    assert json_response(conn, 201)["message"] == "Event created successfully"
    assert json_response(conn, 201)["event_id"] == 1

    # Fetch the created event from the database
    event = Repo.get_by(Event, id: 1)
    assert event
    assert event.description == "A conference about blockchain technology."
    assert event.location == "San Francisco, CA"
    assert event.cover == "https://example.com/cover.jpg"
    assert not event.onchain

    # Check that the ticket tiers were created
    ticket_tiers = Repo.all(from tt in TicketTier, where: tt.event_id == ^event.id)
    assert length(ticket_tiers) == 2
    assert Enum.any?(ticket_tiers, fn tier -> tier.name == "General Admission" end)
    assert Enum.any?(ticket_tiers, fn tier -> tier.name == "VIP" end)
  end

  test "returns error when required fields are missing", %{conn: conn} do
    required_fields = ["name", "start", "end", "description", "location", "cover", "ticket_tiers"]

    Enum.each(required_fields, fn field ->
      # Remove one required field at a time
      invalid_attrs = Map.drop(@valid_event_attrs, [field])

      conn = post(conn, "/api/events/create", %{"event" => invalid_attrs})

      assert json_response(conn, 422)["errors"][field] == ["Can't be blank"]
    end)

    # Test with an empty ticket tier list
    empty_tiers = Map.replace(@valid_event_attrs, "ticket_tiers", [])
    conn = post(conn, "/api/events/create", %{"event" => empty_tiers})

    assert json_response(conn, 422)["errors"]["ticket_tiers"] == ["Can't be blank"]
  end

  test "returns error when fields are in the wrong format", %{conn: conn} do
    required_fields = ["name", "start", "end", "description", "location", "cover", "ticket_tiers"]

    Enum.each(required_fields, fn field ->
      invalid_attrs =
        cond do
          is_bitstring(@valid_event_attrs[field]) ->
            Map.replace(@valid_event_attrs, field, 1)

          is_integer(@valid_event_attrs[field]) ->
            Map.replace(@valid_event_attrs, field, "Some string")

          is_list(@valid_event_attrs[field]) ->
            Map.replace(@valid_event_attrs, field, true)
        end

      conn = post(conn, "/api/events/create", %{"event" => invalid_attrs})

      assert json_response(conn, 422)["errors"][field] == ["Is invalid"]
    end)

    # Test with an empty ticket tier list
    invalid_address_format =
      Map.replace(@valid_event_attrs, "treasury", "Some string that is not a starknet address")

    conn = post(conn, "/api/events/create", %{"event" => invalid_address_format})

    assert json_response(conn, 422)["errors"]["treasury"] == ["Has invalid format"]
  end
end
