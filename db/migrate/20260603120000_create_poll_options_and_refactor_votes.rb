class CreatePollOptionsAndRefactorVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :poll_options do |t|
      t.references :poll, null: false, foreign_key: true
      t.string :text, null: false
      t.timestamps
    end

    add_reference :votes, :poll_option, foreign_key: true

    # Remove duplicate votes keeping only the latest per user per poll
    execute <<~SQL
      DELETE FROM votes
      WHERE id NOT IN (
        SELECT MAX(id) FROM votes GROUP BY poll_id, user_id
      )
    SQL

    add_index :votes, [:poll_id, :user_id], unique: true
    remove_column :votes, :answer, :string
  end
end
