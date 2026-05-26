class ChatMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  # POST /polls/:poll_id/conversations/:conversation_id/chat_messages
  def create
    user_content = params.require(:chat_message).permit(:content)[:content]

    @conversation
      .with_instructions(system_prompt, replace: false)
      .ask(user_content)

    redirect_to poll_conversation_path(@conversation.poll, @conversation)
  rescue StandardError => e
    Rails.logger.error "LLM Error: #{e.class} - #{e.message}"
    redirect_to poll_conversation_path(@conversation.poll, @conversation),
                alert: "Erreur IA : #{e.message}"
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:conversation_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to polls_path, alert: "Conversation introuvable."
  end

  def system_prompt
    poll = @conversation.poll

    <<~PROMPT
      Tu es DebatAI, un assistant expert en analyse de débats et d'opinions.

      Sujet du débat : "#{poll.title_question}"

      Ton rôle :
      - Présenter les arguments pour ET contre de manière équilibrée
      - Identifier les biais cognitifs ou rhétoriques dans les arguments
      - Encourager la pensée critique et le dialogue constructif
      - Rester strictement neutre — ne jamais prendre parti

      Format : Réponds en Markdown (titres ##, listes -, texte en **gras** si nécessaire).
      Sois concis. Réponds dans la langue de l'utilisateur.
    PROMPT
  end
end
