class UpdateCountryValuesInPolls < ActiveRecord::Migration[8.1]
  def up
    Poll.where(country: "france").update_all(country: "FR")
    Poll.where(country: "global").update_all(country: "global")
  end
  
  def down
    Poll.where(country: "FR").update_all(country: "france")
  end
end
