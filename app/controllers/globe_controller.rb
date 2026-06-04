class GlobeController < ApplicationController
  def index
    @polls = Poll.where.not(lat: nil, lon: nil).includes(:votes)
  end
end
