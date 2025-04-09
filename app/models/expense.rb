class Expense < ApplicationRecord
  belongs_to :trip
  belongs_to :participant  # the one who paid

  has_many :expense_shares, dependent: :destroy
  has_many :shared_participants, through: :expense_shares, source: :participant

  # This method calculates the share amount for each participant involved in the expense.
  def calculate_shares
    if shared_participants.any?
      share_amount = amount / (shared_participants.count + 1)
      
      expense_shares.each do |share|
        if share.participant == participant  # Check if it's the payer
          share.update(amount_owed: amount - (shared_participants.count * share_amount))
        else
          share.update(amount_owed: share_amount)
        end
      end
      
      # Ensure there's a share record for the payer if they weren't in shared_participants
      unless expense_shares.exists?(participant: participant)
        expense_shares.create(participant: participant, amount_owed: amount - (shared_participants.count * share_amount))
      end
    end
  end

  # This method calculates the amount the person who paid the expense is also owed.
  def update_payer_owed(share_amount)
    # Calculate the amount owed to the payer by subtracting the total amount shared
    # from the original expense amount.
    payer_share = amount - (shared_participants.count * share_amount)

    # Create an ExpenseShare record for the payer, showing how much they are owed.
    # This is necessary, because the person who pays, is also a participant.
    expense_shares.create(participant: participant, amount_owed: payer_share)
  end

end
