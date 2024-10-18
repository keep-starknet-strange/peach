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

  def index(conn, params) do
    case Events.get_events(params) do
      {:ok, events} ->
        conn
        |> put_status(:ok)
        |> json(%{events: events})

      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: error})
    end
  end

  @doc """
  Updates an event.
  """
  def update(conn, %{"id" => id, "event" => event_params}) do
    case Events.update_event(id, event_params) do
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

  def remaining_event_tickets(conn, %{"id" => id}) do
    case Events.remaining_event_tickets(id) do
      [] ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: "Event not found"})
       ticket_tier ->
        conn
        |> put_status(:ok)
        |> json(%{tickets: ticket_tier})

    end
  end
end
