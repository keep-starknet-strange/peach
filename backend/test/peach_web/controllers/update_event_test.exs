defmodule PeachWeb.EventUpdateControllertest do
  use PeachWeb.ConnCase, async: true

  alias Peach.Event
  alias Peach.Repo

  @original_event %Event{
    name: "Original Name",
    start: ~N[2024-01-01 10:00:00],
    end: ~N[2024-01-01 16:00:00],
    description: "Original description",
    location: "Original location",
    cover: "https://example.com/original_cover.jpg",
    treasury: "0xdead"
  }

  setup do
    # Create an initial event record for testing
    {:ok, event} =
      Repo.insert(@original_event)

    {:ok, event: event}
  end

  test "updates the event fields", %{conn: conn} do
    updated_fields = [
      {"name", "Updated name"},
      {"description", "Updated description"},
      {"location", "Updated location"},
      {"treasury", "0xbeef"},
      {"start", "2024-01-01T11:00:00"},
      {"end", "2024-01-01T13:00:00"},
      {"cover", "https://example.com/updated_cover.jpg"}
    ]

    expected_event = @original_event

    Enum.reduce(updated_fields, expected_event, fn {field, value}, acc ->
      conn = patch(conn, "/api/events/1", %{"event" => %{"#{field}" => value}})
      acc = Map.replace(acc, String.to_atom(field), value)

      # Assert response status
      assert conn.status == 204
      event = Repo.get_by(Event, id: 1)
      assert event
      assert event.name == acc.name
      assert event.description == acc.description
      assert event.location == acc.location
      assert event.cover == acc.cover
      acc
    end)
  end

  test "fail to update the event fields", %{conn: conn} do
    updated_fields = [
      {"name", 1},
      {"description", 2},
      {"location", 3},
      {"treasury", "wrong treasury format"},
      {"treasury", 1},
      {"start", "~N[2024-01-01 14:00:00]"},
      {"start", "2024-01-02T10:00:00"},
      {"end", "wrong type"},
      {"cover", 4}
    ]

    expected_event = @original_event

    Enum.each(updated_fields, fn {field, value} ->
      conn = patch(conn, "/api/events/1", %{"event" => %{"#{field}" => value}})

      # Assert response status
      assert conn.status == 400
      event = Repo.get_by(Event, id: 1)
      assert event
      assert event.name == expected_event.name
      assert event.description == expected_event.description
      assert event.location == expected_event.location
      assert event.cover == expected_event.cover
    end)
  end
end
