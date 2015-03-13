class TracksController < ApplicationController
  def index
    @tracks = Track.all
  end

  def show
    @track = Track.includes(:timesheets).find(params[:id])
    @track_record = @track.track_record
  end
end
