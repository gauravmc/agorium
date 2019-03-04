module ApplicationHelper
  def page_title(prefix = "Agorium", suffix)
    title = prefix
    title += " - #{suffix}" if suffix.present?
    title
  end
end
