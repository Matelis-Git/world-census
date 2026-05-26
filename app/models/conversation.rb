class Conversation < ApplicationRecord
  acts_as_chat

  belongs_to :user
  belongs_to :poll

  has_many :chat_messages, dependent: :destroy
end
