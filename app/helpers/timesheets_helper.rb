module TimesheetsHelper

  def difference_class(time)
    if time > 0
      "plus"
    elsif time == 0
      "best"
    else
      "minus"
    end
  end

end
