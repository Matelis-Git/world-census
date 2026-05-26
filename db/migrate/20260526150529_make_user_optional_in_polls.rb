class MakeUserOptionalInPolls < ActiveRecord::Migration[8.1]
  def change
    change_column_null :polls, :user_id, true
  end
end
