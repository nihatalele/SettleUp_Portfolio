class AddCurrencyToExpenses < ActiveRecord::Migration[8.0]
  def change
   unless column_exists?(:expenses, :currency)
    add_column :expenses, :currency, :string
   end
  end
end
