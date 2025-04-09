class ExpenseShare < ApplicationRecord
  belongs_to :expense
  belongs_to :participant

  # Add an 'amount_owed' attribute to store the calculated amount owed by each participant.
  # Set a default value of 0.0 to ensure it's initialized.
  attribute :amount_owed, :decimal, default: 0.0
end
