class Expense < ApplicationRecord
  CATEGORIES = {
    food: 0,
    lodging: 1,
    gas: 2,
    entertainment: 3,
    other: 4
  }

  def category_name
    CATEGORIES.key(self[:category])
  end

  belongs_to :trip
  belongs_to :participant  # the one who paid

  has_many :expense_shares, dependent: :destroy
  has_many :shared_participants, through: :expense_shares, source: :participant

  # Recalculate shares based on exactly what was checked in the form.
  def calculate_shares
    # Remove old share records
    expense_shares.destroy_all

    # Determine sharers from form input
    sharer_ids = Array(shared_participant_ids).map(&:to_i)
    return if sharer_ids.empty?

    # Split the total equally among all sharers
    split_amount = amount.to_f / sharer_ids.size

    # Create a fresh share for each selected participant
    sharer_ids.each do |pid|
      expense_shares.create!(participant_id: pid, amount_owed: split_amount)
    end
  end
end
