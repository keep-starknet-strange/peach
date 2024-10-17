defmodule PeachWeb.TicketTierController do
  use PeachWeb, :controller
  alias Peach.TicketTiers

  def index(conn, %{"id" => event_id}) do
    ticket_tiers = TicketTiers.event_ticket_tiers(event_id)

    conn
    |> put_status(:ok)
    |> json(%{ticket_tiers: ticket_tiers})
  end

  def show(conn, %{"id" => ticket_tier_id}) do
    case TicketTiers.remaining_tickets(ticket_tier_id) do
      {:ok, ticket_tier} ->
        conn
        |> put_status(:ok)
        |> json(%{ticket_tier: ticket_tier})

      {:error, error} ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: error})
    end
  end
end
