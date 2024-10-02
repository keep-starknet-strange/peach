import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :venuela_backend, VenuelaBackend.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "venuela_backend_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :venuela_backend, VenuelaBackendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "CivUWocGsceVtejxam3MT7w51Q9/UYNArM8wNwrYadEaRWhP39NuT/O9uI5SMbRq",
  server: false

# In test we don't send emails
config :venuela_backend, VenuelaBackend.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime