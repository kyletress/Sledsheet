class TracksController < ApplicationController
  def index
    @tracks = Track.all
  end

  def show
    @track = Track.find(params[:id])
    @track_record = @track.track_record
    @five_day_forecast = @track.weather_forecast.daily.data.first(5)
  end
end
