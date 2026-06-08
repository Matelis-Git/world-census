class AddExpiresAtToPolls < ActiveRecord::Migration[8.1]
  def change
    add_column :polls, :expires_at, :datetime
  end
end
