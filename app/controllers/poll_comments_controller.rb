class PollCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_poll

  def create
    @comment = @poll.poll_comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @poll }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "discussion-form",
            partial: "poll_comments/form",
            locals: { poll: @poll }
          )
        }
        format.html { redirect_to @poll }
      end
    end
  end

  def destroy
    @comment = @poll.poll_comments.find(params[:id])
    return unless @comment.user == current_user

    @comment.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("comment-#{@comment.id}") }
      format.html { redirect_to @poll }
    end
  end

  private

  def set_poll
    @poll = Poll.find(params[:poll_id])
  end

  def comment_params
    params.require(:poll_comment).permit(:body, :parent_id)
  end
end
