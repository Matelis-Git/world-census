# app/controllers/polls_controller.rb
class PollsController < ApplicationController
  def index
    @polls = Poll.includes(:poll_options, :votes).order(created_at: :desc)
    @polls = @polls.where(category: params[:category]) if params[:category].present?
    @polls = @polls.where(country: params[:country]) if params[:country].present?
    if user_signed_in?
      @user_votes = Vote.where(poll: @polls, user: current_user).index_by(&:poll_id)
    end
  end

  def show
    @poll = Poll.includes(:poll_options, :votes).find(params[:id])
    @user_vote = Vote.find_by(poll: @poll, user: current_user) if user_signed_in?
    @votes_by_country = country_vote_data(@poll).filter_map { |k, v| [k, v[:color]] if v[:color] }.to_h
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
    render json: country_vote_data(@poll).transform_values { |v| v[:color] }
  end

  private

  OPTION_COLORS = ["#03C988", "#FF7A2F", "#06B6D4", "#FFEB00"].freeze

  def country_vote_data(poll)
    option_ids = poll.poll_options.map(&:id)
    tallies = poll.votes.where.not(country: nil)
                  .group(:country, :poll_option_id)
                  .count

    result = {}
    tallies.each do |(country, option_id), count|
      result[country] ||= { total: 0, winner_count: 0, color: nil }
      result[country][:total] += count
      if count > result[country][:winner_count]
        idx = option_ids.index(option_id)
        if idx
          result[country][:winner_count] = count
          result[country][:color] = OPTION_COLORS[idx]
        end
      end
    end

    result.transform_values { |v| { color: v[:color], total: v[:total] } }
  end

  def poll_params
    params.require(:poll).permit(:title_question, :category, :country, poll_options_attributes: [:id, :text, :_destroy])
  end
end
