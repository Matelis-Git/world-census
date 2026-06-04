# app/controllers/polls_controller.rb
class PollsController < ApplicationController
  def index
    @polls = Poll.includes(:poll_options, :votes).all
    @polls = @polls.where(category: params[:category]) if params[:category].present?
    @polls = @polls.where(country: params[:country]) if params[:country].present?
    if user_signed_in?
      @user_votes = Vote.where(poll: @polls, user: current_user).index_by(&:poll_id)
    end
  end

  def show
    @poll = Poll.includes(:poll_options, :votes).find(params[:id])
    @user_vote = Vote.find_by(poll: @poll, user: current_user) if user_signed_in?
  end

  def new
    @poll = Poll.new
    2.times { @poll.poll_options.build }
  end

  def create
    @poll = Poll.new(poll_params)
    @poll.user = current_user if user_signed_in?
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

  def my_polls
    @polls = current_user.polls.includes(:poll_options, :votes)
    @user_votes = Vote.where(poll: @polls, user: current_user).index_by(&:poll_id)
  end

  def my_votes
    @votes = current_user.votes.includes(poll: [:poll_options, :votes])
  end

  def country_votes
    @poll = Poll.includes(:poll_options, :votes).find(params[:id])
    option_colors = ["#03C988", "#FF7A2F", "#06B6D4", "#FFEB00"]
    option_ids = @poll.poll_options.map(&:id)

    # Count votes per [country, option] pair
    tallies = @poll.votes.where.not(country: nil)
                   .group(:country, :poll_option_id)
                   .count

    # For each country pick the option with the most votes
    winners = {}
    tallies.each do |(country, option_id), count|
      if winners[country].nil? || count > winners[country][:count]
        idx = option_ids.index(option_id)
        winners[country] = { count: count, color: option_colors[idx] } if idx
      end
    end

    render json: winners.transform_values { |v| v[:color] }
  end

  private

  def poll_params
    params.require(:poll).permit(:title_question, :category, :country, poll_options_attributes: [:id, :text, :_destroy])
  end
end
