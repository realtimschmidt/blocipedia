module ApplicationHelper
  def markdown(text)
    require 'redcarpet'
    renderer = Redcarpet::Render::HTML.new
    extensions = { :autolink => true }
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
  end
end
