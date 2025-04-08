class Expense < ApplicationRecord
  belongs_to :trip
  belongs_to :participant  # the one who paid

  has_many :expense_shares, dependent: :destroy
  has_many :shared_participants, through: :expense_shares, source: :participant
end
