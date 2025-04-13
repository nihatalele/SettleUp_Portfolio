class Participant < ApplicationRecord
  belongs_to :trip
  has_many :expenses  # expenses paid by this participant

  has_many :expense_shares
  has_many :shared_expenses, through: :expense_shares, source: :expense

  # Calculate the total amount spent by this participant.
  def total_spent
    expenses.sum(:amount)
  end

  # Calculate the total amount owed to this participant by others.
  def total_owed
    ExpenseShare.joins(:expense)
                .where(expenses: { trip: trip })
                .where(expense_shares: { participant: self })
                .where.not(expenses: { participant: self })
                .sum(:amount_owed)
  end

  # Calculate how much this participant owes each other participant.
  def owes_to_each
    owes = {}
    trip.participants.each do |other_participant|
      next if other_participant == self # Skip self
      owed = ExpenseShare.joins(:expense)
                         .where(expenses: { trip: trip })
                         .where(expense_shares: { participant: self })
                         .where(expenses: { participant: other_participant })
                         .sum(:amount_owed)
      owes[other_participant.name] = owed if owed > 0
    end
    owes
  end
end
