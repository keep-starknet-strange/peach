defmodule PeachWeb.TicketTierController do
  use PeachWeb, :controller
  alias Peach.TicketTiers

  def index(conn, %{"event_id" => event_id}) do
    case TicketTiers.event_ticket_tiers(event_id) do
      {:ok, ticket_tiers} ->
        conn
        |> put_status(:ok)
        |> json(%{ticket_tiers: ticket_tiers})

      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: error})
    end
  end
end
