defmodule BankAPI.Accounts do
  import Ecto.Query, warn: false

  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.OpenAccount
  alias Commanded.UUID
  alias Ecto.Changeset
  alias BankAPI.Repo

  def get_account(uuid), do: Repo.get!(Account, uuid)

  def open_account(account_params) do
    changeset = account_opening_changeset(account_params)

    if changeset.valid? do
      account_uuid = UUID.uuid4()

      dispatch_result =
        %OpenAccount{
          initial_balance: changeset.changes.initial_balance,
          account_uuid: account_uuid
        }
        |> BankAPI.Manager.dispatch()

      IO.inspect(dispatch_result)

      case dispatch_result do
        :ok ->
          {:ok,
           %Account{
             uuid: account_uuid,
             current_balance: changeset.changes.initial_balance
           }}

        reply ->
          reply
      end
    else
      {:validation_error, changeset}
    end
  end

  defp account_opening_changeset(params) do
    {
      params,
      %{initial_balance: :integer}
    }
    |> Changeset.cast(params, [:initial_balance])
    |> Changeset.validate_required([:initial_balance])
    |> Changeset.validate_number(:initial_balance, greater_than: 0)
  end
end
