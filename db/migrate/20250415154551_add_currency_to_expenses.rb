class AddCurrencyToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :currency, :string
  end
end
