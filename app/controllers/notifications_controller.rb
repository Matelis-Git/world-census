class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @mentions = PollComment
      .includes(:user, :poll)
      .where("body LIKE ?", "%@#{current_user.username}%")
      .order(created_at: :desc)

    @timed_polls = Poll
      .where(user: current_user)
      .where.not(expires_at: nil)
      .order(created_at: :desc)

    @notifications = (@mentions.to_a + @timed_polls.to_a)
      .sort_by(&:created_at).reverse
  end
end
