class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @my_polls = current_user.polls.includes(:poll_options, :votes)
    @votes    = current_user.votes.includes(poll: %i[poll_options votes])

    @category_colors = {
      "economy" => "#03C988",
      "politics" => "#FF204E",
      "social" => "#FFC193",
      "law" => "#FFA500",
      "environment" => "#4ecb8d",
      "technology" => "#7b8fff"
    }

    @votes_by_category = @votes.joins(:poll).group("polls.category").count
    @top_categories    = @votes_by_category.sort_by { |_, v| -v }.first(3)
    @total_votes       = @votes.size

    # Trend dynamique — basé sur les vrais votes par catégorie
    # On simule une progression sur 6 mois à partir du total réel
    @trend_data = @votes_by_category
                  .sort_by { |_, v| -v }
                  .first(4)
                  .each_with_object({}) do |(cat, total_count), hash|
                    seed_val = total_count * 10
                    points   = 6.times.map do |i|
                      base  = (seed_val * (i + 1) / 6.0).round
                      noise = rand(-3..3)
                      [base + noise, 0].max
                    end
                    points[-1] = seed_val
                    hash[cat]  = points
                  end

    # Si pas de votes — données placeholder
    if @trend_data.empty?
      @trend_data = {
        "politics" => [10, 18, 22, 30, 38, 45],
        "economy" => [5, 12, 20, 25, 32, 40],
        "social" => [8,  14, 18, 22, 28, 35],
        "environment" => [3,  8, 12, 18, 24, 30]
      }
    end

    @trend_evolution = @trend_data.transform_values do |points|
      points.last - (points[-2] || 0)
    end

    @level = case @total_votes
             when 0..9   then { number: 1, name: "Newcomer",     xp_max: 10  }
             when 10..24 then { number: 2, name: "Citizen",      xp_max: 25  }
             when 25..49 then { number: 3, name: "Global Voice", xp_max: 50  }
             when 50..99 then { number: 4, name: "World Leader", xp_max: 100 }
             else             { number: 5, name: "Legend",       xp_max: 100 }
             end

    @xp_percent = (@total_votes.to_f / @level[:xp_max] * 100).round.clamp(0, 100)
  end

  def ai_summary
    votes             = current_user.votes.joins(:poll)
    my_polls          = current_user.polls
    votes_by_category = votes.group("polls.category").count
    total_votes       = votes.size

    top_cats = votes_by_category.sort_by { |_, v| -v }.first(4)
    category_summary = top_cats.map do |cat, count|
      pct = total_votes > 0 ? (count.to_f / total_votes * 100).round : 0
      "#{cat} (#{pct}%)"
    end.join(", ")

    recent_polls = my_polls.order(created_at: :desc).limit(3).pluck(:title_question).join("; ")

    level_name = case total_votes
                 when 0..9   then "Newcomer"
                 when 10..24 then "Citizen"
                 when 25..49 then "Global Voice"
                 when 50..99 then "World Leader"
                 else             "Legend"
                 end

    prompt = <<~PROMPT
      User profile on World Census, a global political opinion polling platform:
      - Total votes cast: #{total_votes}
      - Top topics voted on: #{category_summary.presence || "none yet"}
      - Polls created: #{my_polls.size}
      - Level: #{level_name}
      #{recent_polls.present? ? "- Recent polls created: #{recent_polls}" : ""}

      Write a warm, personal 60-word opinion profile summary. Describe this user's voting patterns and topics of interest based on their data. Be specific, not generic. Do not use bullet points.
    PROMPT

    response   = RubyLLM.chat.ask(prompt)
    @summary   = response.content
  rescue StandardError
    @error = true
  end
end
