module ApplicationHelper

  # Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = "Sledsheet"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def nice_date(date)
    date.strftime("%B %d, %Y")
  end
  
  def display_time(i)
    unless i.nil?
      sprintf("%.2f", i / 100.00)
    end
  end
end
