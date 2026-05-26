# app/controllers/votes_controller.rb
class VotesController < ApplicationController
  skip_before_action :authenticate_user!
  def create
    @poll = Poll.find(params[:poll_id])
    @vote = Vote.new(poll: @poll, user: current_user, answer: params[:answer])
    @vote.save
    redirect_to polls_path
  end
end
