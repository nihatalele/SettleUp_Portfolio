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
end
