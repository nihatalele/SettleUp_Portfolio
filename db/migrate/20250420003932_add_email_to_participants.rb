class AddEmailToParticipants < ActiveRecord::Migration[6.1]
  def change
    add_column :participants, :email, :string
    add_index  :participants, [ :trip_id, :email ], unique: true
  end
end
