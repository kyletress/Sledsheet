class TracksController < ApplicationController
  def index
    @tracks = Track.all
  end

  def show
    @track = Track.includes(:timesheets).find(params[:id])
  end
end
