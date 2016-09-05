module TimesheetsHelper

  def difference_class(time)
    if time && time > 0
      "plus"
    elsif time == 0
      "best"
    else
      "minus"
    end
  end

  def track_time(timesheet)
    timesheet.date.in_time_zone(timesheet.track.time_zone).to_s(:starts_at)
  end

  def local_time(timesheet)
    timesheet.date.in_time_zone(current_user.time_zone).to_s(:starts_at) if current_user
  end

end
