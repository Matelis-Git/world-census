class MakeUserOptionalInVotes < ActiveRecord::Migration[8.1]
  def change
    change_column_null :votes, :user_id, true
  end
end
