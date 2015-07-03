class SeasonsController < ApplicationController
  def index
    @seasons = Season.all
  end

  def show
    @season = Season.find(params[:id])
    @mens = Point.season_points(@season, true)
    @womens = Point.season_points(@season, false)
  end
end
