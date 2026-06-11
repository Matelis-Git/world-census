# class ConversationsController < ApplicationController
#   before_action :authenticate_user!
#   before_action :set_poll

#   def index
#     @conversations = @poll.conversations.where(user: current_user).order(created_at: :desc)
#   end

#   def show
#     @conversation = @poll.conversations.where(user: current_user).find(params[:id])
#     @messages = @conversation.chat_messages.order(created_at: :asc)
#     @new_message = ChatMessage.new
#   rescue ActiveRecord::RecordNotFound
#     redirect_to poll_conversations_path(@poll), alert: "Conversation introuvable."
#   end

#   def create
#     @conversation = @poll.conversations.build(user: current_user)

#     if @conversation.save
#       redirect_to poll_conversation_path(@poll, @conversation), notice: "Nouvelle conversation démarrée !"
#     else
#       redirect_to poll_path(@poll), alert: "Impossible de créer la conversation."
#     end
#   end

#   private

#   def set_poll
#     @poll = Poll.find(params[:poll_id])
#   rescue ActiveRecord::RecordNotFound
#     redirect_to polls_path, alert: "Sondage introuvable."
#   end
# end
class ConversationsController < ApplicationController
  def new
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.chat_messages.order(created_at: :asc)
    @new_message = ChatMessage.new
  end

  def create
    @conversation = Conversation.create!(intent: params[:intent] || "generate")

    most_voted_poll = Poll.joins(:votes).group(:id).order('COUNT(votes.id) DESC').first
    most_voted_text = most_voted_poll ? "'#{most_voted_poll.title_question}' (#{most_voted_poll.votes.count} votes)" : "no polls yet"

    initial_message = case params[:intent]
    when "trending"
      "Show me what's trending. The most engaged poll on World Census right now is: #{most_voted_text}. Then show what's trending in the news across economy, politics and social topics. 150 words max."
    when "explore"
      "Help me explore a poll — explain what makes a good poll question and what kind of debates they spark."
    when "guide"
      "Guide me through the app options on World Census: browsing polls, voting, creating a poll, and using the AI assistant."
    else
      category = params.dig(:poll, :category).presence || "any topic"
      country = params.dig(:poll, :country).presence || "global"
      question = params.dig(:poll, :title_question).presence

      if question.present?
        "The user is writing a poll question: '#{question}' in the category '#{category}' for #{country}. Generate 3 improved or related poll question suggestions. Just give me 3 numbered questions, nothing else."
      else
        "Generate 3 poll question suggestions for the category '#{category}' focused on #{country}. Give me only 3 numbered questions, nothing else."
      end
    end
    @conversation.ask(initial_message)
    redirect_to conversation_path(@conversation)
  end

  def create_ai_conversation_with_poll_context
    @poll = Poll.find(params[:poll_id])
    @conversation = Conversation.create!(intent: "ai_poll_context")
    @conversation.chat_messages.create!(content: "What do you want to know about: #{@poll.title_question}?",
                                        role: "assistant")
    @conversation.update(poll_id: @poll.id)
    redirect_to conversation_path(@conversation)
  end
  
  def create_ai_conversation
      @conversation = Conversation.create!(intent: "ai")

      @conversation.chat_messages.create!(content: "Hello! How are you doing today? How can I assist you?",
                                          role: "assistant")
      redirect_to conversation_path(@conversation)
    end
end
