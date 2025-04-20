class Participant < ApplicationRecord
  belongs_to :trip
  has_many :expenses  # expenses paid by this participant

  # When a participant goes away, first destroy their expenses and shares
  has_many :expenses,        dependent: :destroy
  has_many :expense_shares,  dependent: :destroy
  has_many :shared_expenses, through: :expense_shares, source: :expense

  # Validations
  validates :name,  presence: true
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { scope: :trip_id }

  # Calculate the total amount spent by this participant.
  def total_spent
    expenses.sum(:amount)
  end

  # Calculate the total amount owed to this participant by others.
  def total_owed
    ExpenseShare
      .joins(:expense)
      .where(expenses: { trip: trip })
      .where(expense_shares: { participant: self })
      .where.not(expenses: { participant: self })
      .sum(:amount_owed)
  end

  # Calculate how much this participant owes each other participant.
  def owes_to_each
    owes = {}
    trip.participants.each do |other|
      next if other == self
      owed = ExpenseShare
               .joins(:expense)
               .where(expenses: { trip: trip })
               .where(expense_shares: { participant: self })
               .where(expenses: { participant: other })
               .sum(:amount_owed)
      owes[other.name] = owed if owed.positive?
    end
    owes
  end

  # Calculate the net balance owed between this participant and another.
  def net_balance(other)
    owed_to_other = ExpenseShare
                      .joins(:expense)
                      .where(expenses: { trip: trip })
                      .where(expense_shares: { participant: self })
                      .where(expenses: { participant: other })
                      .sum(:amount_owed)

    owed_by_other = ExpenseShare
                      .joins(:expense)
                      .where(expenses: { trip: trip })
                      .where(expense_shares: { participant: other })
                      .where(expenses: { participant: self })
                      .sum(:amount_owed)

    owed_to_other - owed_by_other
  end
end
