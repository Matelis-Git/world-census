class ChatMessagesController < ApplicationController
  before_action :set_conversation

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

    <<~PROMPT
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
  end
end
