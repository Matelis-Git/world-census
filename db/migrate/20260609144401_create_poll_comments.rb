class CreatePollComments < ActiveRecord::Migration[8.1]
  def change
    create_table :poll_comments do |t|
      t.references :poll, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.integer :parent_id

      t.timestamps
    end
    add_index :poll_comments, :parent_id
  end
end
