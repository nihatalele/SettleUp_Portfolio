# app/models/trip.rb
class Trip < ApplicationRecord
    belongs_to :user
    has_many   :participants, dependent: :destroy
    has_many   :expenses,     dependent: :destroy

    # Scope: returns trips you own or are invited to by participant email
    scope :for_user, ->(user) {
      left_joins(:participants)
        .where(
          "trips.user_id = :uid OR participants.email = :email",
          uid:   user.id,
          email: user.email
        )
        .distinct
    }

    # Authorization helper: true if user owns the trip or their email is listed
    def accessible_by?(user)
      return false unless user
      user.id == user_id || participants.where(email: user.email).exists?
    end
end
