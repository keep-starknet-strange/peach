defmodule PeachWeb.GetEventControllerTest do
  use PeachWeb.ConnCase, async: true
  alias Peach.Event
  alias Peach.OnchainEvent
  alias Peach.Repo
  alias Peach.TicketTier

  setup do
    # Insert sample events
    event1 =
      Repo.insert!(%Event{
        description: "A conference about blockchain technology.",
        location: "San Francisco, CA",
        cover: "https://example.com/cover.jpg",
        ticket_tiers: [
          %TicketTier{
            name: "General Admission",
            description: "Access to all sessions",
            price: 5,
            max_supply: 100
          },
          %TicketTier{
            name: "VIP",
            description: "Access to VIP sessions and perks",
            price: 10,
            max_supply: 20
          }
        ],
        name: "Past Event",
        start: ~N[2024-11-05 09:00:00],
        end: ~N[2024-11-06 17:00:00],
        treasury: "0xbeef"
      })

    event2 =
      Repo.insert!(%Event{
        description: "A conference about blockchain technology.",
        location: "San Francisco, CA",
        cover: "https://example.com/cover.jpg",
        ticket_tiers: [
          %TicketTier{
            name: "General Admission",
            description: "Access to all sessions",
            price: 5,
            max_supply: 100
          },
          %TicketTier{
            name: "VIP",
            description: "Access to VIP sessions and perks",
            price: 10,
            max_supply: 20
          }
        ],
        name: "Current Event",
        start: ~N[2024-11-10 09:00:00],
        end: ~N[2024-11-12 17:00:00],
        treasury: "0xbeef"
      })

    event3 =
      Repo.insert!(%Event{
        description: "A conference about blockchain technology.",
        location: "San Francisco, CA",
        cover: "https://example.com/cover.jpg",
        ticket_tiers: [
          %TicketTier{
            name: "General Admission",
            description: "Access to all sessions",
            price: 5,
            max_supply: 100
          },
          %TicketTier{
            name: "VIP",
            description: "Access to VIP sessions and perks",
            price: 10,
            max_supply: 20
          }
        ],
        name: "Future Event",
        start: ~N[2024-11-15 09:00:00],
        end: ~N[2024-11-17 17:00:00],
        treasury: "0xbeef"
      })

    Repo.insert!(%Event{
      description: "A conference about blockchain technology.",
      location: "San Francisco, CA",
      cover: "https://example.com/cover.jpg",
      ticket_tiers: [
        %TicketTier{
          name: "General Admission",
          description: "Access to all sessions",
          price: 5,
          max_supply: 100
        },
        %TicketTier{
          name: "VIP",
          description: "Access to VIP sessions and perks",
          price: 10,
          max_supply: 20
        }
      ],
      name: "Not onchain Event",
      start: ~N[2024-11-15 09:00:00],
      end: ~N[2024-11-17 17:00:00],
      treasury: "0xbeef"
    })

    Repo.insert(%OnchainEvent{id: "0x01_0x02", event_id: event1.id, onchain: true})
    Repo.insert(%OnchainEvent{id: "0x02_0x03", event_id: event2.id, onchain: true})
    Repo.insert(%OnchainEvent{id: "0x03_0x04", event_id: event3.id, onchain: true})
    {:ok, event1: event1, event2: event2, event3: event3}
  end

  test "returns events without optional params", %{conn: conn} do
    conn = get(conn, "/api/events")
    response = json_response(conn, 422)
    assert response["errors"]["after_datetime"] == "Can't be blank"
  end

  test "returns validation error for invalid after_datetime", %{conn: conn} do
    after_datetime = "invalid-time-format"
    after_event_id = 1
    first = 10
    conn = get(conn, "/api/events?after_datetime=#{after_datetime}")

    response = json_response(conn, 422)
    assert response["errors"]["after_datetime"] == "invalid_format"

    conn =
      get(conn, "/api/events?after_datetime=#{after_datetime}&after_event_id=#{after_event_id}")

    response = json_response(conn, 422)
    assert response["errors"]["after_datetime"] == "invalid_format"

    conn =
      get(conn, "/api/events?after_datetime=#{after_datetime}&first=#{first}")

    response = json_response(conn, 422)
    assert response["errors"]["after_datetime"] == "invalid_format"

    conn =
      get(
        conn,
        "/api/events?after_datetime=#{after_datetime}&after_event_id=#{after_event_id}&first=#{first}"
      )

    response = json_response(conn, 422)
    assert response["errors"]["after_datetime"] == "invalid_format"
  end

  test "returns validation error for non-integer after_event_id", %{conn: conn} do
    after_datetime = "2024-11-08T00:00:00"
    after_event_id = "not-an-integer"
    first = 10

    conn =
      get(conn, "/api/events?after_datetime=#{after_datetime}&after_event_id=#{after_event_id}")

    response = json_response(conn, 422)
    assert response["errors"]["after_event_id"] == "invalid_type"

    conn =
      get(
        conn,
        "/api/events?after_datetime=#{after_datetime}&after_event_id=#{after_event_id}&first=#{first}"
      )

    response = json_response(conn, 422)
    assert response["errors"]["after_event_id"] == "invalid_type"
  end

  test "returns validation error for non-integer first", %{conn: conn} do
    after_datetime = "2024-11-08T00:00:00"
    after_event_id = 1
    first = "not an integer"

    conn =
      get(conn, "/api/events?after_datetime=#{after_datetime}&first=#{first}")

    response = json_response(conn, 422)
    assert response["errors"]["first"] == "invalid_type"

    conn =
      get(
        conn,
        "/api/events?after_datetime=#{after_datetime}&after_event_id=#{after_event_id}&first=#{first}"
      )

    response = json_response(conn, 422)
    assert response["errors"]["first"] == "invalid_type"
  end

  test "limits the number of events returned with first param", %{conn: conn, event2: event2} do
    after_datetime = "2024-11-08T00:00:00"
    first = 1
    conn = get(conn, "/api/events?after_datetime=#{after_datetime}&first=#{first}")

    assert json_response(conn, 200)["events"] == [
             %{
               "id" => event2.id,
               "name" => event2.name,
               "description" => event2.description,
               "start" => NaiveDateTime.to_iso8601(event2.start),
               "end" => NaiveDateTime.to_iso8601(event2.end),
               "location" => event2.location,
               "cover" => event2.cover,
               "treasury" => event2.treasury
             }
           ]
  end

  test "returns events after specified time and id", %{conn: conn, event2: event2, event3: event3} do
    after_datetime = "2024-11-08T00:00:00"
    after_event_id = "#{event2.id}"
    first = "10"

    expected_event =
      [
        %{
          "id" => event3.id,
          "name" => event3.name,
          "description" => event3.description,
          "start" => NaiveDateTime.to_iso8601(event3.start),
          "end" => NaiveDateTime.to_iso8601(event3.end),
          "location" => event3.location,
          "cover" => event3.cover,
          "treasury" => event3.treasury
        }
      ]

    conn =
      get(
        conn,
        "/api/events?after_datetime=#{after_datetime}&after_event_id=#{after_event_id}&first=#{first}"
      )

    assert json_response(conn, 200)["events"] == expected_event

    conn =
      get(
        conn,
        "/api/events?after_datetime=#{after_datetime}&after_event_id=#{after_event_id}"
      )

    assert json_response(conn, 200)["events"] == expected_event

    after_datetime = "2024-11-16T00:00:00"

    conn =
      get(
        conn,
        "/api/events?after_datetime=#{after_datetime}"
      )

    assert json_response(conn, 200)["events"] == expected_event
  end
end
