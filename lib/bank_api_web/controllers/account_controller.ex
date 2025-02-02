defmodule BankAPIWeb.AccountController do
  alias BankAPI.Accounts
  alias BankAPI.Accounts.Projections.Account
  use BankAPIWeb, :controller

  action_fallback BankAPIWeb.FallbackController

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.open_account(account_params) do
      conn
      |> put_status(:created)
      |> render(:show, account: account)
    end
  end
end
