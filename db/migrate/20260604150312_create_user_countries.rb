class CreateUserCountries < ActiveRecord::Migration[8.1]
  def change
    create_table :user_countries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :country_code

      t.timestamps
    end
  end
end
