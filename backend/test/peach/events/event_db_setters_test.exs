defmodule Peach.Events.EventDBSettersTest do
  use Peach.DataCase, async: true

  alias Peach.Event
  alias Peach.Events
  alias Peach.Repo

  setup do
    # Create an initial event record for testing
    {:ok, event} =
      Repo.insert(%Event{
        name: "Original Name",
        date: ~N[2024-01-01 10:00:00],
        description: "Original description",
        location: "Original location",
        cover: "https://example.com/original_cover.jpg",
        onchain: false,
        treasury: "0xdead"
      })

    {:ok, event: event}
  end

  test "updates name in the database", %{event: event} do
    updated_name = "Updated Name"
    Events.update_event_name(event.id, updated_name)
    updated_event = Repo.get!(Event, event.id)
    assert updated_event.name == updated_name
    Events.update_event_name(event.id, 1)
    updated_event = Repo.get!(Event, event.id)
    assert updated_event.name == updated_name
  end

  test "updates date in the database", %{event: event} do
    new_date = ~N[2025-12-31 23:59:59]
    Events.update_event_date(event.id, new_date)
    updated_event = Repo.get!(Event, event.id)
    assert updated_event.date == new_date
    Events.update_event_date(event.id, 1)
    updated_event = Repo.get!(Event, event.id)
    assert updated_event.date == new_date
  end

  test "updates description in the database", %{event: event} do
    updated_description = "Updated description"
    Events.update_event_description(event.id, updated_description)
    updated_event = Repo.get!(Event, event.id)
    assert updated_event.description == updated_description
    Events.update_event_description(event.id, 1)
    updated_event = Repo.get!(Event, event.id)
    assert updated_event.description == updated_description
  end

  test "updates location in the database", %{event: event} do
    updated_location = "Updated location"
    Events.update_event_location(event.id, updated_location)
    updated_event = Repo.get!(Event, event.id)
    assert updated_event.location == updated_location
    Events.update_event_location(event.id, 1)
    updated_event = Repo.get!(Event, event.id)
    assert updated_event.location == updated_location
  end

  test "updates cover in the database", %{event: event} do
    updated_cover = "https://example.com/updated_cover.jpg"
    Events.update_event_cover(event.id, updated_cover)
    updated_event = Repo.get!(Event, event.id)
    assert updated_event.cover == updated_cover
    Events.update_event_cover(event.id, 1)
    updated_event = Repo.get!(Event, event.id)
    assert updated_event.cover == updated_cover
  end

  test "updates treasury in the database", %{event: event} do
    updated_treasury = "0xbeef"
    Events.update_event_treasury(event.id, updated_treasury)
    updated_event = Repo.get!(Event, event.id)
    assert updated_event.treasury == updated_treasury
    Events.update_event_treasury(event.id, "beef")
    assert updated_event.treasury == updated_treasury
  end
end
