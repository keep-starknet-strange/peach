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

  @doc """
  Updates the name of an event.
  """
  def update_event_name(conn, %{"id" => id, "name" => name}) do
    case Peach.Events.update_event_name(id, name) do
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
  Updates the date of an event.
  """
  def update_event_date(conn, %{"id" => id, "date" => date}) do
    case Events.update_event_cover(id, date) do
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
