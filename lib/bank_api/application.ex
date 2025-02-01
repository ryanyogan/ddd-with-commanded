defmodule BankAPI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BankAPIWeb.Telemetry,
      BankAPI.Repo,
      BankAPI.Manager,
      {DNSCluster, query: Application.get_env(:bank_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BankAPI.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BankAPI.Finch},
      BankAPIWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BankAPI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BankAPIWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
