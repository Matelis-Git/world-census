class ChatMessage < ApplicationRecord
  include ActionView::RecordIdentifier

  acts_as_message chat: :conversation, tool_calls_foreign_key: :message_id

  belongs_to :conversation

  after_create_commit :broadcast_append_to_conversation
  after_update_commit :broadcast_replace_to_conversation

  def broadcast_append_to_conversation
    broadcast_append_to conversation, target: "chat-messages", partial: "conversations/message",
                                      locals: { message: self }
  end

  def broadcast_replace_to_conversation
    broadcast_replace_to conversation, target: ActionView::RecordIdentifier.dom_id(self),
                                       partial: "conversations/message", locals: { message: self }
  end
end
