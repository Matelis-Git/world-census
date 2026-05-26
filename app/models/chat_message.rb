class ChatMessage < ApplicationRecord
  acts_as_message chat: :conversation, tool_calls_foreign_key: :message_id

  belongs_to :conversation
end
