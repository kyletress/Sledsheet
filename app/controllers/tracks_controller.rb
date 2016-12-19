class TracksController < ApplicationController
  def index
    @tracks = Track.all
  end

  def show
    @track = Track.find(params[:id])
    @track_record = @track.track_record
    @sr_men = @track.start_record_men
    @sr_women = @track.start_record_women
    @tr_men = @track.track_record_men
    @tr_women = @track.track_record_women
    @five_day_forecast = @track.weather_forecast.daily.data.first(5)
  end
end
