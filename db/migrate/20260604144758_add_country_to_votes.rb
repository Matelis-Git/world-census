class AddCountryToVotes < ActiveRecord::Migration[8.1]
  def change
    add_column :votes, :country, :string
  end
end
