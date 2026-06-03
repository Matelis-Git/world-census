# app/controllers/votes_controller.rb
class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @poll = Poll.find(params[:poll_id])
    @vote = Vote.find_or_initialize_by(poll: @poll, user: current_user)
    @vote.poll_option_id = params[:poll_option_id]
    @vote.save
    redirect_back fallback_location: polls_path
  end
end
