class Conversation < ApplicationRecord
  acts_as_chat messages: :chat_messages

  belongs_to :user
  belongs_to :poll
  has_many :chat_messages, dependent: :destroy
end
