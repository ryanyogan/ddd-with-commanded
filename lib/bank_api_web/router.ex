defmodule BankAPIWeb.Router do
  use BankAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankAPIWeb do
    pipe_through :api

    resources "/accounts", AccountController, only: [:create]
  end

  if Application.compile_env(:bank_api, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BankAPIWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
