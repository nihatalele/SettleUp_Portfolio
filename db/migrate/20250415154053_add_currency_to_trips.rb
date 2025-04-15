class AddCurrencyToTrips < ActiveRecord::Migration[8.0]
  def change
   unless column_exists?(:trips, :currency)
    add_column :trips, :currency, :string
   end
  end
end