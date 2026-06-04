class PollOption < ApplicationRecord
  belongs_to :poll
  has_many :votes, dependent: :nullify

  validates :text, length: { maximum: 50 }
end
