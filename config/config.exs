# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :meetings,
  ecto_repos: [Meetings.Repo]

# Configures the endpoint
config :meetings, Meetings.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HTo+w7PP33irY7IratmeVKxrEa2fRma8aLJx/cTMvNTpmjOpdQYB822ujMbrSDPW",
  render_errors: [view: Meetings.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Meetings.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Meetings.User,
  repo: Meetings.Repo,
  module: Meetings,
  logged_out_url: "/",
  email_from_name: "Wichita Public Meetings",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :registerable]

config :coherence, Meetings.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%
