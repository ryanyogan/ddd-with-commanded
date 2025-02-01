import Config

config :bank_api,
  namespace: BankAPI,
  ecto_repos: [BankAPI.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :bank_api, BankAPIWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: BankAPIWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: BankAPI.PubSub,
  live_view: [signing_salt: "PnLJXJpB"]

config :bank_api, BankAPI.Mailer, adapter: Swoosh.Adapters.Local

config :bank_api, event_stores: [BankAPI.EventStore]

config :commanded_ecto_projections,
  repo: BankAPI.Repo

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  bank_api: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  bank_api: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
