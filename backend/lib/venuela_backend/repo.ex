defmodule VenuelaBackend.Repo do
  use Ecto.Repo,
    otp_app: :venuela_backend,
    adapter: Ecto.Adapters.Postgres
end
