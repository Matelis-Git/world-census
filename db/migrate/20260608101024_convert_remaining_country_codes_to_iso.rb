class ConvertRemainingCountryCodesToIso < ActiveRecord::Migration[8.1]
  def up
    {
      "germany"   => "DE",
      "brazil"    => "BR",
      "argentina" => "AR",                                  
      "colombia"  => "CO"                                                                                           
    }.each do |old, new|
      Poll.where(country: old).update_all(country: new)
    end
  end

  def down
    {
      "DE" => "germany",                                                                                            
      "BR" => "brazil",
      "AR" => "argentina",
      "CO" => "colombia"
    }.each do |old, new| 
      Poll.where(country: old).update_all(country: new)
    end
  end
end
