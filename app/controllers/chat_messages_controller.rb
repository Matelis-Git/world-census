class ChatMessagesController < ApplicationController
  before_action :set_conversation
  OPTION_COLORS = ["#03C988", "#FF7A2F", "#06B6D4", "#FFEB00"].freeze

  def create
    user_content = params.require(:chat_message).permit(:content)[:content]

    @conversation
      .with_instructions(system_prompt, replace: false)
      .ask(user_content)
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

 def system_prompt
    intent = @conversation.intent
    poll   = @conversation.poll

    base = <<~PROMPT
      You are Census AI, a global opinion assistant.
      Keep all responses under 50 words. Be concise and direct.
      Always respond with a short sentence followed by 2-4 options when possible.

      Your role depends on the user's intent: #{intent}
      - "trending": Show what topics are trending in France and globally across Economy, Politics, Social categories
      - "generate": Help the user write a clear poll question based on a topic or news headline
      - "explore": Explain what a poll means and summarise the debate around it
      - "guide": Guide the user through what they can do on World Census

      Rules:
      - Never write long paragraphs
      - Stay neutral and factual
      - Respond in the user's language
    PROMPT

    return base unless poll

    "#{base}\n#{poll_context(poll)}"
  end

  def poll_context(poll)
    votes_arr = poll.votes.to_a
    total     = votes_arr.size

    results = poll.poll_options.map do |opt|
      count = votes_arr.count { |v| v.poll_option_id == opt.id }
      pct   = total > 0 ? (count.to_f / total * 100).round : 0
      "#{opt.text} (#{pct}%)"
    end.join(", ")

    country_data = country_vote_data(poll)
    top_countries = country_data.sort_by { |_, v| -v[:total] }.first(3).map do |code, _|
      ISO3166::Country[code]&.iso_short_name || code
    end.join(", ")

    recent_comments = poll.poll_comments
                          .where(parent_id: nil)
                          .order(created_at: :desc)
                          .limit(3)
                          .pluck(:body)
                          .join(" | ")

    <<~CONTEXT
      If a user asks a question related to a specific poll, use the context of that poll to inform your answer.
      - Poll: "#{poll.title_question}"
      - Results (#{total} votes): #{results.presence || 'no votes yet'}
      - Top voting countries: #{top_countries.presence || 'no geographic data'}
      - Discussion highlights: #{recent_comments.presence || 'no discussion yet'}
    CONTEXT
  end

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
end
