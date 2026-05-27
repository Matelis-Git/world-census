class Conversation < ApplicationRecord
  acts_as_chat messages: :chat_messages

  belongs_to :user, optional: true
  belongs_to :poll, optional: true
  has_many :chat_messages, dependent: :destroy
end
