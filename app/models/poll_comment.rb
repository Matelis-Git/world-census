class PollComment < ApplicationRecord
  belongs_to :poll
  belongs_to :user
  belongs_to :parent, class_name: "PollComment", optional: true
  has_many :replies, class_name: "PollComment", foreign_key: :parent_id,
                     dependent: :destroy, inverse_of: :parent

  validates :body, presence: true, length: { maximum: 500 }

  after_create_commit :broadcast_comment
  after_destroy_commit { broadcast_remove_to "poll_#{poll_id}_comments", target: "comment-#{id}" }

  private

  def broadcast_comment
    if parent_id.nil?
      broadcast_remove_to "poll_#{poll_id}_comments", target: "empty-comments-poll-#{poll_id}"
      broadcast_prepend_to "poll_#{poll_id}_comments",
        target: "comments-poll-#{poll_id}",
        partial: "poll_comments/comment",
        locals: { comment: self }
    else
      broadcast_append_to "poll_#{poll_id}_comments",
        target: "replies-#{parent_id}",
        partial: "poll_comments/comment",
        locals: { comment: self }
    end
  end
end
