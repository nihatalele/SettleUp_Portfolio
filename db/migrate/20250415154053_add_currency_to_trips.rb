class AddCurrencyToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :currency, :string
  end
end
