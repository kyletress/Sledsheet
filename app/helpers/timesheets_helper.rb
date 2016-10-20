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

  # helper to build the graph
  def graph_for(constant, series_ids)
    constant = params[:constant] || @timesheet.best_runs.first
    series_ids = params[:series] || @timesheet.runs.limit(5).ids
    line_chart by_run_api_v1_timesheet_graph_path(@timesheet, constant: constant, series: series_ids)
  end

end
