use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dndgame, DndgameWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :dndgame, Dndgame.Repo,
  username: "dndgame",
  password: "dndgame",
  database: "dndgame_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
