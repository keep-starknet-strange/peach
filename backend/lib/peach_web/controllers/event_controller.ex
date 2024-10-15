defmodule PeachWeb.EventController do
  use PeachWeb, :controller
  alias Peach.Events

  def create(conn, %{"event" => event_params}) do
    case Events.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_status(:created)
        |> json(%{message: "Event created successfully", event_id: event.id})

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
            Phoenix.Naming.humanize(msg)
          end)

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors})
    end
  end

  def events(conn, params) do
    with {:ok, after_datetime} <- validate_datetime(Map.get(params, "after_datetime")),
         {:ok, after_event_id} <-
           validate_integer(Map.get(params, "after_event_id", 0), "after_event_id"),
         {:ok, first} <- validate_integer(Map.get(params, "first", 50), "first") do
      # Fetch events and map them to desired structure
      events =
        Events.get_events(after_datetime, after_event_id, first)
        |> Enum.map(&format_event/1)

      conn
      |> put_status(:ok)
      |> json(%{events: events})
    else
      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: error})
    end
  end

  defp validate_datetime(nil), do: {:error, %{after_datetime: "Can't be blank"}}

  defp validate_datetime(datetime_str) do
    case NaiveDateTime.from_iso8601(datetime_str) do
      {:ok, datetime} -> {:ok, datetime}
      {:error, reason} -> {:error, %{after_datetime: reason}}
    end
  end

  defp validate_integer(value, _field) when is_integer(value), do: {:ok, value}

  defp validate_integer(value, field) do
    case Integer.parse(value) do
      {int, ""} -> {:ok, int}
      _ -> {:error, %{field => "invalid_type"}}
    end
  end

  defp format_event(event),
    do: %{
      "id" => event.id,
      "name" => event.name,
      "description" => event.description,
      "start" => event.start,
      "end" => event.end,
      "location" => event.location,
      "cover" => event.cover
    }

  @doc """
  Updates the name of an event.
  """
  def update_event_name(conn, %{"id" => id, "name" => name}) do
    case Events.update_event_name(id, name) do
      {:ok, _event} ->
        conn
        |> put_status(:no_content)

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
            Phoenix.Naming.humanize(msg)
          end)

        conn
        |> put_status(:bad_request)
        |> json(%{errors: errors})
    end
  end

  @doc """
  Updates the starting datetime of an event.
  """
  def update_event_start(conn, %{"id" => id, "start" => start}) do
    case Events.update_event_start(id, start) do
      {:ok, _event} ->
        conn
        |> put_status(:no_content)

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
            Phoenix.Naming.humanize(msg)
          end)

        conn
        |> put_status(:bad_request)
        |> json(%{errors: errors})
    end
  end

  @doc """
  Updates the ending datetime of an event.
  """
  def update_event_end(conn, %{"id" => id, "end" => end_date}) do
    case Events.update_event_end(id, end_date) do
      {:ok, _event} ->
        conn
        |> put_status(:no_content)

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
            Phoenix.Naming.humanize(msg)
          end)

        conn
        |> put_status(:bad_request)
        |> json(%{errors: errors})
    end
  end

  @doc """
  Updates the description of an event.
  """
  def update_event_description(conn, %{"id" => id, "description" => description}) do
    case Events.update_event_description(id, description) do
      {:ok, _event} ->
        conn
        |> put_status(:no_content)

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
            Phoenix.Naming.humanize(msg)
          end)

        conn
        |> put_status(:bad_request)
        |> json(%{errors: errors})
    end
  end

  @doc """
  Updates the location of an event.
  """
  def update_event_location(conn, %{"id" => id, "location" => location}) do
    case Events.update_event_location(id, location) do
      {:ok, _event} ->
        conn
        |> put_status(:no_content)

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
            Phoenix.Naming.humanize(msg)
          end)

        conn
        |> put_status(:bad_request)
        |> json(%{errors: errors})
    end
  end

  @doc """
  Updates the cover of an event.
  """
  def update_event_cover(conn, %{"id" => id, "cover" => cover}) do
    case Events.update_event_cover(id, cover) do
      {:ok, _event} ->
        conn
        |> put_status(:no_content)

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
            Phoenix.Naming.humanize(msg)
          end)

        conn
        |> put_status(:bad_request)
        |> json(%{errors: errors})
    end
  end

  @doc """
  Updates the treasury of an event.
  """
  def update_event_treasury(conn, %{"id" => id, "treasury" => treasury}) do
    case Events.update_event_treasury(id, treasury) do
      {:ok, _event} ->
        conn
        |> put_status(:no_content)

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
            Phoenix.Naming.humanize(msg)
          end)

        conn
        |> put_status(:bad_request)
        |> json(%{errors: errors})
    end
  end
end
