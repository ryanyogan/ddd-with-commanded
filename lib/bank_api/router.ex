defmodule BankAPI.Router do
  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.OpenAccount
  use Commanded.Commands.Router

  dispatch(OpenAccount, to: Account, identity: :account_uuid)
end
