class UserCountry < ApplicationRecord
  belongs_to :user
  validates :country_code, uniqueness: { scope: :user_id }
end
