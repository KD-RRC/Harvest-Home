module SearchHelper
  def highlight_query(text, query)
    return text if query.blank?
    text.to_s.gsub(/#{Regexp.escape(query)}/i) { |match| "<mark>#{match}</mark>" }.html_safe
  end
end