defmodule BankAPIWeb.AccountJSON do
  alias BankAPI.Accounts.Projections.Account

  def show(%{account: account}) do
    %{data: data(account)}
  end

  defp data(%Account{} = account) do
    %{
      uuid: account.uuid,
      current_balance: account.current_balance
    }
  end
end
