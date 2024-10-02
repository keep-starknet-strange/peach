defmodule PeachBackend.Repo do
  use Ecto.Repo,
    otp_app: :peach_backend,
    adapter: Ecto.Adapters.Postgres
end
