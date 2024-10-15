defmodule Peach.Events do
  @moduledoc """
  Manages the events for the peach app
  """
  alias Peach.Event
  alias Peach.Repo
  import Ecto.Query

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
  def get_events(after_datetime, after_event_id, first) do
    Repo.all(
      from e in Event,
        where: e.end >= ^after_datetime and e.id > ^after_event_id,
        order_by: [asc: e.start, asc: e.id],
        limit: ^first
    )
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
