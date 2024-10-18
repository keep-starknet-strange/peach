defmodule Peach.Events do
  @moduledoc """
  Manages the events for the peach app
  """
  alias Peach.Event
  alias Peach.Repo
  alias Peach.TicketTiers
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

  def remaining_event_tickets(event_id) do
    Enum.map(TicketTiers.event_ticket_tiers(event_id), fn ticket_tier ->
      {:ok, remaining} = TicketTiers.remaining_tickets(ticket_tier.id)
      remaining
    end)
  end

  @doc """
  Returns the `first` events that end after `after_time` and their id is after `after_event_id`
  """
  def get_events(%{
        "after_datetime" => after_datetime,
        "after_event_id" => after_event_id,
        "first" => first
      }) do
    case {NaiveDateTime.from_iso8601(after_datetime), Integer.parse(after_event_id),
          Integer.parse(first)} do
      {{:ok, datetime}, {event_id, _}, {first, _}} ->
        {:ok,
         Repo.all(
           from e in Event,
             where: e.end >= ^datetime and e.id > ^event_id,
             order_by: [asc: e.start, asc: e.id],
             limit: ^first
         )}

      {{:error, error}, _, _} ->
        {:error, %{after_datetime: error}}

      {_, :error, _} ->
        {:error, %{after_event_id: "invalid_type"}}

      {_, _, :error} ->
        {:error, %{first: "invalid_type"}}
    end
  end

  def get_events(%{"after_datetime" => after_datetime, "after_event_id" => after_event_id}) do
    case {NaiveDateTime.from_iso8601(after_datetime), Integer.parse(after_event_id)} do
      {{:ok, datetime}, {event_id, _}} ->
        {:ok,
         Repo.all(
           from e in Event,
             where: e.end >= ^datetime and e.id > ^event_id,
             order_by: [asc: e.start, asc: e.id],
             limit: ^@default_limit
         )}

      {{:error, error}, _} ->
        {:error, %{after_datetime: error}}

      {_, :error} ->
        {:error, %{after_event_id: "invalid_type"}}
    end
  end

  def get_events(%{"after_datetime" => after_datetime, "first" => limit}) do
    case {NaiveDateTime.from_iso8601(after_datetime), Integer.parse(limit)} do
      {{:ok, datetime}, {first, _}} ->
        {:ok,
         Repo.all(
           from e in Event,
             where: e.end >= ^datetime and e.id > ^@default_event_id,
             order_by: [asc: e.start, asc: e.id],
             limit: ^first
         )}

      {{:error, error}, _} ->
        {:error, %{after_datetime: error}}

      {_, :error} ->
        {:error, %{first: "invalid_type"}}
    end
  end

  def get_events(%{"after_datetime" => after_datetime}) do
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

  def get_events(_params) do
    {:error, %{after_datetime: "Can't be blank"}}
  end

  @doc """
  Updates the event 
  """
  def update_event(id, event) do
    current_event = Repo.get!(Event, id)

    current_event
    |> Event.update_changeset(event)
    |> Repo.update()
  end
end
