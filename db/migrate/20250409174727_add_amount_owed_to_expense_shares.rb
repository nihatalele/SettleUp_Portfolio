class AddAmountOwedToExpenseShares < ActiveRecord::Migration[8.0]
  def change
    add_column :expense_shares, :amount_owed, :decimal
  end
end
