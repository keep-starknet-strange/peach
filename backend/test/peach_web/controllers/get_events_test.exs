defmodule PeachWeb.GetEventControllerTest do
  use PeachWeb.ConnCase, async: true
  alias Peach.Event
  alias Peach.Repo

  setup do
    # Insert sample events
    event1 =
      Repo.insert!(%Event{
        name: "Past Event",
        start: ~N[2024-11-05 09:00:00],
        end: ~N[2024-11-06 17:00:00]
      })

    event2 =
      Repo.insert!(%Event{
        name: "Current Event",
        start: ~N[2024-11-10 09:00:00],
        end: ~N[2024-11-12 17:00:00]
      })

    event3 =
      Repo.insert!(%Event{
        name: "Future Event",
        start: ~N[2024-11-15 09:00:00],
        end: ~N[2024-11-17 17:00:00]
      })

    {:ok, event1: event1, event2: event2, event3: event3}
  end

  test "returns events after specified time and id", %{conn: conn, event2: event2, event3: event3} do
    after_datetime = "2024-11-08T00:00:00"
    after_event_id = "#{event2.id}"
    first = "10"

    conn =
      get(
        conn,
        "/api/events?after_datetime=#{after_datetime}&after_event_id=#{after_event_id}&first=#{first}"
      )

    assert json_response(conn, 200)["events"] == [
             %{
               "id" => event3.id,
               "name" => event3.name,
               "description" => event3.description,
               "start" => NaiveDateTime.to_iso8601(event3.start),
               "end" => NaiveDateTime.to_iso8601(event3.end),
               "location" => event3.location,
               "cover" => event3.cover
             }
           ]
  end

  test "returns events without optional params", %{conn: conn} do
    conn = get(conn, "/api/events")
    response = json_response(conn, 422)
    assert response["errors"]["after_datetime"] == "Can't be blank"
  end

  test "returns validation error for invalid after_datetime", %{conn: conn} do
    after_datetime = "invalid-time-format"
    conn = get(conn, "/api/events?after_datetime=#{after_datetime}")

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
               "cover" => event2.cover
             }
           ]
  end
end
