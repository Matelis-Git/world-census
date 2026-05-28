# app/controllers/polls_controller.rb
class PollsController < ApplicationController

  def index
    @polls = Poll.all
    @polls = @polls.where(category: params[:category]) if params[:category].present?
    @polls = @polls.where(country: params[:country]) if params[:country].present?
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(poll_params)
    # @poll.user = current_user
    if @poll.save
      redirect_to polls_path, notice: "Poll created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @poll = Poll.find(params[:id])
    @poll.destroy
    redirect_to polls_path
  end

  private

  def poll_params
    params.require(:poll).permit(:title_question, :category, :country)
  end
end
