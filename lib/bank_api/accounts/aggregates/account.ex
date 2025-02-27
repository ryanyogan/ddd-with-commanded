defmodule BankAPI.Accounts.Aggregates.Account do
  defstruct [:uuid, :current_balance]

  alias __MODULE__
  alias BankAPI.Accounts.Events.AccountOpened
  alias BankAPI.Accounts.Commands.OpenAccount

  def execute(
        %Account{uuid: nil},
        %OpenAccount{
          account_uuid: account_uuid,
          initial_balance: initial_balance
        }
      )
      when initial_balance > 0 do
    %AccountOpened{
      account_uuid: account_uuid,
      initial_balance: initial_balance
    }
  end

  def execute(%Account{uuid: nil}, %OpenAccount{initial_balance: initial_balance})
      when initial_balance <= 0 do
    {:error, :initial_balance_must_be_above_zero}
  end

  def execute(%Account{}, %OpenAccount{}) do
    {:error, :account_already_opened}
  end

  # State Mutators

  def apply(%Account{} = account, %AccountOpened{
        account_uuid: account_uuid,
        initial_balance: initial_balance
      }) do
    %Account{account | uuid: account_uuid, current_balance: initial_balance}
  end
end
