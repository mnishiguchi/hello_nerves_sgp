# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hello_nerves_sgp_ui,
  ecto_repos: [HelloNervesSgpUi.Repo]

# Configures the endpoint
config :hello_nerves_sgp_ui, HelloNervesSgpUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7zmyRnGDXtHZzWKgJd+OVdFBjAWnEQ0+8MNJh7Co+W0Kx8SA7nFKv4hV1jv2/FKH",
  render_errors: [view: HelloNervesSgpUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HelloNervesSgpUi.PubSub,
  live_view: [signing_salt: "vFmNCqiS"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
