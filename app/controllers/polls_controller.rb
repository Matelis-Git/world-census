# app/controllers/polls_controller.rb
class PollsController < ApplicationController
  def index
    @polls = Poll.includes(:poll_options, :votes).order(created_at: :desc)
    @polls = @polls.where(category: params[:category]) if params[:category].present?
    @polls = @polls.where(country: params[:country]) if params[:country].present?
    return unless user_signed_in?

    @user_votes = Vote.where(poll: @polls, user: current_user).index_by(&:poll_id)
  end

  def show
    @poll = Poll.includes(:poll_options, :votes).find(params[:id])
    @user_vote = Vote.find_by(poll: @poll, user: current_user) if user_signed_in?

    country_data      = country_vote_data(@poll)
    @votes_by_country = country_data.filter_map { |k, v| [k, v[:color]] if v[:color] }.to_h

    poll_total = @poll.votes.size
    @top_countries = country_data
      .sort_by { |_, v| -v[:total] }
      .first(9)
      .map do |code, data|
        pct = poll_total > 0 ? (data[:total].to_f / poll_total * 100).round(1) : 0
        { code: code, total: data[:total], pct: pct }
      end

    @comments = @poll.poll_comments
                     .includes(:user, replies: :user)
                     .where(parent_id: nil)
                     .order(created_at: :desc)
    @related_polls = Poll.includes(:poll_options, :votes)
                         .where(category: @poll.category)
                         .where.not(id: @poll.id)
                         .order(created_at: :desc)
                         .limit(2)
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
    @votes = current_user.votes.includes(poll: %i[poll_options votes])
  end

  def ai_suggestions
    question = params[:question].to_s.strip
    category = params[:category].to_s.strip
    country  = params[:country].to_s.strip
    options  = Array(params[:options]).map(&:to_s).reject(&:empty?)

    prompt = <<~PROMPT
      You are helping someone create a poll for a global political/social platform.
      Context they provided — question: "#{question}", category: #{category}, country: #{country}, current options: #{options.join(", ")}.

      Generate exactly 3 diverse poll suggestions. Each suggestion must have a clear question and 2–4 short answer options.
      Respond ONLY with a valid JSON array, no markdown, no extra text:
      [{"question":"...","options":["...","..."]},{"question":"...","options":["...","...","..."]},{"question":"...","options":["...","..."]}]
    PROMPT

    response = RubyLLM.chat.ask(prompt)
    raw = response.content.strip.gsub(/\A```(?:json)?\n?/, "").gsub(/\n?```\z/, "").strip
    suggestions = JSON.parse(raw)
    render json: { suggestions: suggestions }
  rescue StandardError
    render json: { error: "Could not generate suggestions" }, status: :unprocessable_entity
  end

  def explore
    @polls = Poll.includes(:poll_options, :votes).order(created_at: :desc)
    @polls = @polls.where(category: params[:category]) if params[:category].present?
    if params[:query].present?
      @polls = @polls.where("title_question ILIKE ?", "%#{params[:query].strip}%")
    end

    @tab = params[:tab] || "newest"
    @polls = @polls.to_a
    case @tab
    when "most_voted"
      @polls.sort_by! { |p| -p.votes.size }
    when "trending"
      cutoff = 7.days.ago
      @polls.sort_by! { |p| -(p.votes.select { |v| v.created_at > cutoff }.size) }
    end

    return unless user_signed_in?

    @user_votes = Vote.where(poll_id: @polls.map(&:id), user: current_user).index_by(&:poll_id)
  end

  def ai_summary
    @poll = Poll.includes(:poll_options, :votes).find(params[:id])

    votes_arr = @poll.votes.to_a
    total = votes_arr.size

    results = @poll.poll_options.map do |opt|
      count = votes_arr.count { |v| v.poll_option_id == opt.id }
      pct = total > 0 ? (count.to_f / total * 100).round : 0
      "#{opt.text} (#{pct}%)"
    end.join(", ")

    country_data = country_vote_data(@poll)
    top_countries = country_data.sort_by { |_, v| -v[:total] }.first(3).map do |code, _|
      ISO3166::Country[code]&.iso_short_name || code
    end.join(", ")

    recent_comments = @poll.poll_comments
                           .where(parent_id: nil)
                           .order(created_at: :desc)
                           .limit(3)
                           .pluck(:body)
                           .join(" | ")

    prompt = <<~PROMPT
      Poll: "#{@poll.title_question}"
      Results (#{total} votes): #{results.presence || "no votes yet"}
      Top voting countries: #{top_countries.presence || "no geographic data"}
      Discussion highlights: #{recent_comments.presence || "no discussion yet"}

      Write a concise 100-word insight covering: what this question explores, what the leading result signals, how different countries voted, and key themes from the discussion.
    PROMPT

    response = RubyLLM.chat.ask(prompt)
    @summary = response.content
  rescue StandardError
    @error = true
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
      next unless count > result[country][:winner_count]

      idx = option_ids.index(option_id)
      if idx
        result[country][:winner_count] = count
        result[country][:color] = OPTION_COLORS[idx]
      end
    end

    result.transform_values { |v| { color: v[:color], total: v[:total] } }
  end

  def poll_params
    params.require(:poll).permit(:title_question, :category, :country, :expires_at,
                                 poll_options_attributes: %i[id text _destroy])
  end
end
