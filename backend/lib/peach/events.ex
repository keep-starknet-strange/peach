defmodule Events do
  @moduledoc """
  Manages the events for the peach app
  """
  alias Peach.Event
  alias Peach.Repo

  @doc """
  Creates an event with the given attributes.
  """
  def create_event(event \\ %{}) do
    %Event{}
    |> Event.changeset(event)
    |> Repo.insert()
  end
end
