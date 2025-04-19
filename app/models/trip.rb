class Trip < ApplicationRecord
    has_many :participants, dependent: :destroy
    has_many :expenses, dependent: :destroy
    belongs_to :user
end
