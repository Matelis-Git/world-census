class UserCountriesController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.user_countries.find_or_create_by(country_code: params[:country_code])
    redirect_back fallback_location: polls_path
  end

  def destroy
    uc = current_user.user_countries.find(params[:id])
    uc&.destroy
    redirect_back fallback_location: polls_path
  end
end
