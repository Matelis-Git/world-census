class ChatMessage < ApplicationRecord
  acts_as_message

  belongs_to :conversation
end
