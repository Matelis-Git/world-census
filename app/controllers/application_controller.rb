class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:country])
  end

  before_action :load_globe_polls

  def load_globe_polls
    @globe_polls = Poll.where.not(lat: nil, lon: nil).includes(:votes) rescue []
  end
end
