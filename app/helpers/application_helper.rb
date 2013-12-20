module ApplicationHelper

  def file_to_string(file_path)
    sha = Digest::SHA1.hexdigest(file_path)
    Rails.cache.fetch ["file", sha].join('-') do
      File.open(file_path, 'rb') { |f| f.read }
    end
  end

  
  def markdown(text)
    sha = Digest::SHA1.hexdigest(text)
    Rails.cache.fetch ["file", sha].join('-') do
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
      options = {
        autolink: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true
      }
      Redcarpet::Markdown.new(renderer, options).render(text).html_safe
    end
  end

  def twitterized_type(type)
    case type
      when :alert
        "alert-danger"
      when :error
        "alert-warning"
      when :notice
        "alert-info"
      when :success
        "alert-success"
      else
        "alert-dismissable"
    end
  end
end
