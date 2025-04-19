class AddUserIdToTrips < ActiveRecord::Migration[6.1]
  def up
    add_reference :trips, :user, null: true, foreign_key: true

    default_user = User.find_by(email: "admin@example.com")
    raise "Admin user not found" unless default_user

    Trip.update_all(user_id: default_user.id)

    change_column_null :trips, :user_id, false
  end

  def down
    remove_reference :trips, :user
  end
end
