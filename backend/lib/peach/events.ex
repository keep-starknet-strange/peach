defmodule Peach.Events do
  @moduledoc """
  Manages the events for the peach app
  """
  alias Peach.Event
  alias Peach.Repo
  import Ecto.Query

  @default_limit 50
  @default_event_id 0

  @doc """
  Creates an event with the given attributes.
  """
  def create_event(event \\ %{}) do
    %Event{}
    |> Event.changeset(event)
    |> Repo.insert()
  end

  @doc """
  Returns the `first` events that end after `after_time` and their id is after `after_event_id`
  """
  def get_events(%{after_datetime: after_datetime, after_event_id: after_event_id, first: first})
      when is_integer(after_event_id) and
             is_integer(first) do
    case NaiveDateTime.from_iso8601(after_datetime) do
      {:ok, datetime} ->
        {:ok,
         Repo.all(
           from e in Event,
             where: e.end >= ^datetime and e.id > ^after_event_id,
             order_by: [asc: e.start, asc: e.id],
             limit: ^first
         )}

      {:error, error} ->
        {:error, %{after_datetime: error}}
    end
  end

  def get_events(%{after_datetime: after_datetime, after_event_id: after_event_id})
      when is_integer(after_event_id) do
    {:ok,
     Repo.all(
       from e in Event,
         where: e.end >= ^after_datetime and e.id > ^after_event_id,
         order_by: [asc: e.start, asc: e.id],
         limit: @default_limit
     )}
  end

  def get_events(%{after_datetime: after_datetime, limit: limit})
      when is_integer(limit) do
    {:ok,
     Repo.all(
       from e in Event,
         where: e.end >= ^after_datetime and e.id > @default_event_id,
         order_by: [asc: e.start, asc: e.id],
         limit: ^limit
     )}
  end

  def get_events(%{after_datetime: after_datetime}) do
    case NaiveDateTime.from_iso8601(after_datetime) do
      {:ok, datetime} ->
        {:ok,
         Repo.all(
           from e in Event,
             where: e.end >= ^datetime and e.id > @default_event_id,
             order_by: [asc: e.start, asc: e.id],
             limit: @default_limit
         )}

      {:error, error} ->
        {:error, %{after_datetime: error}}
    end
  end

  def get_events(%{after_datetime: _after_datetime, limit: _limit}) do
    {:error, %{limit: "incorrect_type"}}
  end

  def get_events(%{after_datetime: _after_datetime, after_event_id: _after_event_id}) do
    {:error, %{after_event_id: "incorrect_type"}}
  end

  def get_events(params) do
    IO.inspect(params)
    {:error, %{after_datetime: "Can't be blank"}}
  end

  @doc """
  Updates the `name` field
  """
  def update_event_name(event_id, name) do
    event = Repo.get!(Event, event_id)

    event
    |> Event.update_changeset(%{name: name})
    |> Repo.update()
  end

  @doc """
  Updates the `description` field
  """
  def update_event_description(event_id, description) do
    event = Repo.get!(Event, event_id)

    event
    |> Event.update_changeset(%{description: description})
    |> Repo.update()
  end

  @doc """
  Updates the `end` field
  """
  def update_event_end(event_id, end_date) do
    event = Repo.get!(Event, event_id)

    event
    |> Event.update_changeset(%{end: end_date})
    |> Repo.update()
  end

  @doc """
  Updates the `start` field
  """
  def update_event_start(event_id, start) do
    event = Repo.get!(Event, event_id)

    event
    |> Event.update_changeset(%{start: start})
    |> Repo.update()
  end

  @doc """
  Updates the `location` field
  """
  def update_event_location(event_id, location) do
    event = Repo.get!(Event, event_id)

    event
    |> Event.update_changeset(%{location: location})
    |> Repo.update()
  end

  @doc """
  Updates the `cover` field
  """
  def update_event_cover(event_id, cover) do
    event = Repo.get!(Event, event_id)

    event
    |> Event.update_changeset(%{cover: cover})
    |> Repo.update()
  end

  @doc """
  Updates the `treasury` field
  """
  def update_event_treasury(event_id, treasury) do
    event = Repo.get!(Event, event_id)

    event
    |> Event.update_changeset(%{treasury: treasury})
    |> Repo.update()
  end
end
