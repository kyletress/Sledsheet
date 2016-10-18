class GetTrackWeatherJob < ActiveJob::Base
  queue_as :default

  def perform(track)
    forecast = ForecastIO.forecast(track.latitude, track.longitude)
    #track.update(weather: forecast["currently"]) cache or update column?
  end
end
