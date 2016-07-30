class GetTimesheetWeatherJob < ActiveJob::Base
  queue_as :default

  def perform(timesheet)
    forecast = ForecastIO.forecast(timesheet.track.latitude, timesheet.track.longitude, time: timesheet.date.to_i)
    timesheet.update(weather: forecast["currently"])
    # if success?. How about if forecast.response, or forecast.body.. etc.
  end
end
