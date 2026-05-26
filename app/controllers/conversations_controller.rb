class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_poll

  def index
    @conversations = @poll.conversations.where(user: current_user).order(created_at: :desc)
  end

  def show
    @conversation = @poll.conversations.where(user: current_user).find(params[:id])
    @messages = @conversation.chat_messages.order(created_at: :asc)
    @new_message = ChatMessage.new
  rescue ActiveRecord::RecordNotFound
    redirect_to poll_conversations_path(@poll), alert: "Conversation introuvable."
  end

  def create
    @conversation = @poll.conversations.build(user: current_user)

    if @conversation.save
      redirect_to poll_conversation_path(@poll, @conversation), notice: "Nouvelle conversation démarrée !"
    else
      redirect_to poll_path(@poll), alert: "Impossible de créer la conversation."
    end
  end

  private

  def set_poll
    @poll = Poll.find(params[:poll_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to polls_path, alert: "Sondage introuvable."
  end
end
