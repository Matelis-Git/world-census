class AddGeoToPoll < ActiveRecord::Migration[8.1]
  def change
    add_column :polls, :lat, :float
    add_column :polls, :lon, :float
    add_column :polls, :city, :string
  end
end
