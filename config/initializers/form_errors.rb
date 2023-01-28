ActionView::Base.field_error_proc = ->(html_tag, instance) {
  if /^<label/.match?(html_tag)
    html_tag
  else
    html = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    html.children.add_class("is-danger")

    error_message_markup = <<~HTML
      <p class='help is-danger'>
        #{sanitize(instance.error_message.to_sentence)}
      </p>
    HTML

    "#{html}#{error_message_markup}".html_safe
  end
}
