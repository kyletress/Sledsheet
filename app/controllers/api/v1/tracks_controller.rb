class Api::V1::TracksController < ApplicationController

  def index
    @tracks = Track.all
  end

  def show
    @track = Track.find(params[:id])
  end

end
