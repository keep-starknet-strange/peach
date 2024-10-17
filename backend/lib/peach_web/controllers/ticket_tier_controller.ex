defmodule PeachWeb.TicketTierController do
  use PeachWeb, :controller
  alias Peach.TicketTiers

  def index(conn, %{"id" => event_id}) do
    ticket_tiers = TicketTiers.event_ticket_tiers(event_id)

    conn
    |> put_status(:ok)
    |> json(%{ticket_tiers: ticket_tiers})
  end
end
