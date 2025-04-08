class Participant < ApplicationRecord
  belongs_to :trip
  has_many :expenses  # expenses paid by this participant

  has_many :expense_shares
  has_many :shared_expenses, through: :expense_shares, source: :expense
end
