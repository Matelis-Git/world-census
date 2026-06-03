class Poll < ApplicationRecord
  has_many :conversations, dependent: :destroy
  belongs_to :user, optional: true
  has_many :votes, dependent: :destroy
  has_many :poll_options, dependent: :destroy
  accepts_nested_attributes_for :poll_options, reject_if: :all_blank
end
