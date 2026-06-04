# app/controllers/votes_controller.rb
class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @poll = Poll.find(params[:poll_id])
    @vote = Vote.find_or_initialize_by(poll: @poll, user: current_user)
    @vote.poll_option_id = params[:poll_option_id]
    @vote.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to polls_path }
    end
  end

  def destroy
    @poll = Poll.find(params[:poll_id])
    @vote = Vote.find_by(poll: @poll, user: current_user)
    @vote&.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("voted-poll-#{@poll.id}") }
      format.html { redirect_to my_votes_polls_path }
    end
  end
end
