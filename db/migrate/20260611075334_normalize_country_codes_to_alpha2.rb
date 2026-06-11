class NormalizeCountryCodesToAlpha2 < ActiveRecord::Migration[8.0]
  def up
    Poll.where.not(country: ["global", nil]).each do |p|
      next if p.country.length == 2
      country = ISO3166::Country.all.find { |c| c.iso_short_name.downcase == p.country.downcase }
      p.update_column(:country, country.alpha2) if country
    end
  end

  def down
    # irréversible
  end
end
