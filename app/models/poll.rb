class Poll < ApplicationRecord
  has_many :conversations, dependent: :destroy
  belongs_to :user, optional: true
  has_many :votes
end

# use this incase you want to delete a poll that already has votes 
# class Poll < ApplicationRecord
#   belongs_to :user, optional: true
#   has_many :votes, dependent: :destroy
# end
