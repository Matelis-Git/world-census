# class ChatMessagesController < ApplicationController
#   before_action :authenticate_user!
#   before_action :set_conversation

#   # POST /polls/:poll_id/conversations/:conversation_id/chat_messages
#   def create
#     user_content = params.require(:chat_message).permit(:content)[:content]

#     @conversation
#       .with_instructions(system_prompt, replace: false)
#       .ask(user_content)

#     redirect_to poll_conversation_path(@conversation.poll, @conversation)
#   rescue StandardError => e
#     Rails.logger.error "LLM Error: #{e.class} - #{e.message}"
#     redirect_to poll_conversation_path(@conversation.poll, @conversation),
#                 alert: "Erreur IA : #{e.message}"
#   end

#   private

#   def set_conversation
#     @conversation = current_user.conversations.find(params[:conversation_id])
#   rescue ActiveRecord::RecordNotFound
#     redirect_to polls_path, alert: "Conversation introuvable."
#   end

#   def system_prompt
#     poll = @conversation.poll

#     <<~PROMPT
#       Tu es DebatAI, un assistant expert en analyse de débats et d'opinions.

#       Sujet du débat : "#{poll.title_question}"

#       Ton rôle :
#       - Présenter les arguments pour ET contre de manière équilibrée
#       - Identifier les biais cognitifs ou rhétoriques dans les arguments
#       - Encourager la pensée critique et le dialogue constructif
#       - Rester strictement neutre — ne jamais prendre parti

#       Format : Réponds en Markdown (titres ##, listes -, texte en **gras** si nécessaire).
#       Sois concis. Réponds dans la langue de l'utilisateur.
#     PROMPT
#   end
# end
class ChatMessagesController < ApplicationController
  before_action :set_conversation

  def create
    user_content = params.require(:chat_message).permit(:content)[:content]

    @conversation
      .with_instructions(system_prompt, replace: false)
      .ask(user_content)

    redirect_to conversation_path(@conversation)
  rescue StandardError => e
    Rails.logger.error "LLM Error: #{e.class} - #{e.message}"
    redirect_to conversation_path(@conversation), alert: "AI Error: #{e.message}"
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def system_prompt
    intent = @conversation.intent

    <<~PROMPT
      You are Census AI, a global opinion assistant.
      Keep all responses under 150 words. Be concise and direct.
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
  end
end

# add static route -> call system prompt in new/cencuslanding
