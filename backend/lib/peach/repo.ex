defmodule Peach.Repo do
  use Ecto.Repo,
    otp_app: :peach,
    adapter: Ecto.Adapters.Postgres
end
