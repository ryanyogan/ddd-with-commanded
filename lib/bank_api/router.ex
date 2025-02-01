defmodule BankAPI.Router do
  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.OpenAccount
  use Commanded.Commands.Router

  middleware(BankAPI.Middleware.ValidateCommand)

  dispatch(OpenAccount, to: Account, identity: :account_uuid)
end
