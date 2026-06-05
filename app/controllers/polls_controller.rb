class PollsController < ApplicationController

  def index
    @polls = Poll.includes(:poll_options, :votes)
                 .all
                 .sort_by { |p| -p.votes.count }
    @polls = @polls.select { |p| p.category == params[:category] } if params[:category].present?
    @polls = @polls.select { |p| p.country  == params[:country]  } if params[:country].present?
    @trending = @polls.first(4)
    if user_signed_in?
      @user_votes = Vote.where(poll: @polls, user: current_user).index_by(&:poll_id)
    end
  end

  def show
    @poll      = Poll.includes(:poll_options, :votes).find(params[:id])
    @user_vote = Vote.find_by(poll: @poll, user: current_user) if user_signed_in?
  end

  def new
    @poll = Poll.new
    2.times { @poll.poll_options.build }
  end

  def create
    @poll      = Poll.new(poll_params)
    @poll.user = current_user if user_signed_in?
    if @poll.save
      redirect_to polls_path, notice: 'Poll created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @poll = Poll.find(params[:id])
    @poll.destroy
    redirect_to polls_path
  end

  def my_polls
    @polls      = current_user.polls.includes(:poll_options, :votes)
    @user_votes = Vote.where(poll: @polls, user: current_user).index_by(&:poll_id)
  end

  def my_votes
    @votes = current_user.votes.includes(poll: [:poll_options, :votes])
  end

  private

  def poll_params
    params.require(:poll).permit(
      :title_question, :category, :country, :image_url,
      poll_options_attributes: [:id, :text, :_destroy]
    )
  end

end
