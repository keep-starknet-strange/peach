defmodule PeachWeb.Router do
  use PeachWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", PeachWeb do
    pipe_through(:api)
    post "/events/create", EventController, :create
    patch "/events/:id/name", EventController, :update_event_name
    patch "/events/:id/description", EventController, :update_event_description
    patch "/events/:id/location", EventController, :update_event_location
    patch "/events/:id/cover", EventController, :update_event_cover
    patch "/events/:id/treasury", EventController, :update_event_treasury
    patch "/events/:id/start", EventController, :update_event_start
    patch "/events/:id/end", EventController, :update_event_end
    get "/events", EventController, :events
    get "/tickets/:address", TicketController, :get_tickets_with_event_by_address
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:peach, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: PeachWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
