defmodule BankAPI.Accounts.AccountsTest do
  alias BankAPI.Accounts
  alias BankAPI.Accounts.Projections.Account
  use BankAPI.Test.InMemoryEventStoreCase

  test "opens account with valid command" do
    params = %{
      "initial_balance" => 1_000
    }

    assert {:ok, %Account{current_balance: 1_000}} = Accounts.open_account(params)
  end
end
