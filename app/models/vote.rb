class Vote < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :poll
  belongs_to :poll_option
  validates :user_id, uniqueness: { scope: :poll_id }
end

