class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @my_polls = current_user.polls.includes(:poll_options, :votes)
    @votes = current_user.votes
    @user_votes = Vote.where(poll: @my_polls, user: current_user).index_by(&:poll_id)
  end
end
