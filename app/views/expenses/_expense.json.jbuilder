json.extract! expense, :id, :description, :amount, :date, :participant_id, :trip_id
json.shared_participant_ids expense.shared_participants.map(&:id)
