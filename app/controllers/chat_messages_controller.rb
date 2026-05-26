class ChatMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    user_content = params.require(:chat_message).permit(:content)[:content]

    @conversation
      .with_instructions(system_prompt, replace: false)
      .ask(user_content)

    redirect_to poll_conversation_path(@conversation.poll, @conversation)
  rescue StandardError => e
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

      Sujet : "#{poll.title}"
      #{"Contexte : #{poll.description}" if poll.description.present?}

      Ton rôle :
      - Présenter les arguments pour ET contre de manière équilibrée
      - Identifier les biais cognitifs dans les arguments
      - Encourager la pensée critique
      - Rester strictement neutre

      Format : Réponds en Markdown. Sois concis. Réponds dans la langue de l'utilisateur.
    PROMPT
  end
  endclass ChatMessagesController < ApplicationController
end
