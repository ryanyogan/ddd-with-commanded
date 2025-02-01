defmodule BankAPI.Accounts do
  import Ecto.Query, warn: false

  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.OpenAccount
  alias Commanded.UUID
  alias Ecto.Changeset
  alias BankAPI.Repo

  def get_account(uuid), do: Repo.get!(Account, uuid)

  def open_account(%{"initial_balance" => initial_balance}) do
    account_uuid = UUID.uuid4()

    dispatch_result =
      %OpenAccount{
        initial_balance: initial_balance,
        account_uuid: account_uuid
      }
      |> BankAPI.Manager.dispatch()

    case dispatch_result do
      :ok ->
        {:ok,
         %Account{
           uuid: account_uuid,
           current_balance: initial_balance
         }}

      reply ->
        reply
    end
  end

  def open_account(_params), do: {:error, :bad_or_unknown_command}
end
