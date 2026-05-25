class CreatePolls < ActiveRecord::Migration[8.1]
  def change
    create_table :polls do |t|
      t.string :title_question
      t.string :category
      t.string :country
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
