class AddRubyLLMFieldsToConversationsAndChatMessages < ActiveRecord::Migration[8.1]
  def change
    # Conversations agit comme un "chat" RubyLLM
    add_column :conversations, :model_id, :string

    # Seulement les colonnes manquantes dans chat_messages
    add_column :chat_messages, :input_tokens, :integer
    add_column :chat_messages, :output_tokens, :integer
    add_column :chat_messages, :model_id, :string

    add_index :chat_messages, [:conversation_id, :created_at]
  end
end
