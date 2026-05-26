# app/controllers/polls_controller.rb
class PollsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @polls = Poll.all
  end

  def create
    @poll = Poll.new(poll_params)
    @poll.user = current_user
    if @poll.save
      redirect_to polls_path, notice: "Poll created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def poll_params
    params.require(:poll).permit(:question, :category, :country)
  end
end
