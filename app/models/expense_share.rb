class ExpenseShare < ApplicationRecord
  belongs_to :expense
  belongs_to :participant
end
