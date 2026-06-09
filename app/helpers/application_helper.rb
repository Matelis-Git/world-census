module ApplicationHelper
  AVATAR_COLORS = %w[#FF6B6B #4ECDC4 #45B7D1 #96CEB4 #FFEAA7 #DDA0DD #98D8C8 #F7DC6F #BB8FCE #85C1E9].freeze

  def avatar_color(username)
    AVATAR_COLORS[username.to_s.chars.sum(&:ord) % AVATAR_COLORS.length]
  end

  def highlight_mentions(text)
    escaped = CGI.escapeHTML(text.to_s)
    escaped.gsub(/@(\w+)/, '<span style="color:#06B6D4; font-weight:600;">@\1</span>').html_safe
  end

  def render_markdown(text)
    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: true,
      filter_html: false,
      safe_links_only: true
    )
    markdown = Redcarpet::Markdown.new(renderer,
                                       autolink: true,
                                       tables: true,
                                       fenced_code_blocks: true,
                                       strikethrough: true,
                                       lax_spacing: true)
    markdown.render(text).html_safe
  end
end
