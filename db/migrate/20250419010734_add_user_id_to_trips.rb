# db/migrate/20250419010734_add_user_id_to_trips.rb
class AddUserIdToTrips < ActiveRecord::Migration[6.1]
  def up
    add_reference :trips, :user, null: true, foreign_key: true

    # Create or find an “admin” account by email,
    # and set its password so Devise validations pass.
    admin = User.find_or_create_by!(email: "admin@example.com") do |u|
      u.password              = "secure_password"
      u.password_confirmation = "secure_password"
    end

    # Backfill all existing trips to belong to that user
    Trip.update_all(user_id: admin.id)

    # Now require every trip to have a user
    change_column_null :trips, :user_id, false
  end

  def down
    remove_reference :trips, :user, foreign_key: true
  end
end
