class MakeUserOptionalInConversations < ActiveRecord::Migration[8.1]
  def change
    change_column_null :conversations, :user_id, true
    change_column_null :conversations, :poll_id, true
  end
end
