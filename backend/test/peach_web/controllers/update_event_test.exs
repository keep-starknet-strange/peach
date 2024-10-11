defmodule PeachWeb.EventUpdateControllertest do
  use PeachWeb.ConnCase, async: true

  alias Peach.Event
  alias Peach.Repo

  @original_event %Event{
    name: "Original Name",
    date: ~N[2024-01-01 10:00:00],
    description: "Original description",
    location: "Original location",
    cover: "https://example.com/original_cover.jpg",
    onchain: false,
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
      {"cover", "https://example.com/updated_cover.jpg"}
    ]

    expected_event = @original_event

    Enum.reduce(updated_fields, expected_event, fn {field, value}, acc ->
      conn = put(conn, "/api/events/1/#{field}", %{"#{field}" => value})
      acc = Map.replace(acc, String.to_atom(field), value)

      # Assert response status
      assert conn.status == 204
      event = Repo.get_by(Event, id: 1)
      assert event
      assert event.name == acc.name
      assert event.description == acc.description
      assert event.location == acc.location
      assert event.cover == acc.cover
      assert not event.onchain
      acc
    end)
  end

  test "fail to update the event fields", %{conn: conn} do
    updated_fields = [
      {"name", 1},
      {"description", 2},
      {"location", 3},
      {"treasury", "wrong treasury format"},
      {"cover", 4}
    ]

    expected_event = @original_event

    Enum.each(updated_fields, fn {field, value} ->
      conn = put(conn, "/api/events/1/#{field}", %{"#{field}" => value})

      # Assert response status
      assert conn.status == 400
      event = Repo.get_by(Event, id: 1)
      assert event
      assert event.name == expected_event.name
      assert event.description == expected_event.description
      assert event.location == expected_event.location
      assert event.cover == expected_event.cover
      assert not event.onchain
    end)
  end
end
