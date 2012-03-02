module ApplicationHelper

  def logo
    image_tag "rails.png", alt: "Sample App", class: "round"
  end

  # Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end
end
