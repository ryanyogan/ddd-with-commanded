defmodule BankAPI.Accounts.Projectors.AccountOpened do
  alias BankAPI.Accounts.Projections.Account
  alias BankAPI.Accounts.Events.AccountOpened

  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.AccountOpened"

  @impl true
  project(%AccountOpened{} = event, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :account_opened, %Account{
      uuid: event.account_uuid,
      current_balance: event.initial_balance
    })
  end)
end
