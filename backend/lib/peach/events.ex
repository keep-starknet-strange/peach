defmodule Events do
  alias Peach.Repo
  alias Peach.Event

  @doc """
  Creates an event with the given attributes.
  """
  def create_event(event \\ %{}) do
    %Event{}
    |> Event.changeset(event)
    |> Repo.insert()
  end
end
