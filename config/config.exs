# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dndgame,
  ecto_repos: [Dndgame.Repo]

# Configures the endpoint
config :dndgame, DndgameWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  secret_key_base: "unqO1DktJZjiORiKv96vtIFP4WgyF46nno6VimjPdWCcvXKQ+uAdllHSuG8MYgod",
  render_errors: [view: DndgameWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Dndgame.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :oauth2, debug: true

config :darkskyx, api_key: System.get_env("DARKSKY_API_KEY"),
       defaults: [
        units: "us",
        lang: "en"
       ]

config :spotify_ex, client_id: System.gen_env("SPOTIFY_CLIENT_ID"),
                    secret_key:  "SPOTIFY_CLIENT_SECRET",
                    user_id: "<YOUR SPOTIFY USER ID>",
                    scopes: ["playlist-read-private", "playlist-modify-private"],
                    callback_url: "https://dndgame.cstransky.me/auth/authenticate/2"


# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
