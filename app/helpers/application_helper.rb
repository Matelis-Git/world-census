module ApplicationHelper
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
