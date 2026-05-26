class Poll < ApplicationRecord
  has_many :conversations, dependent: :destroy
  belongs_to :user, optional: true
  has_many :votes
end


