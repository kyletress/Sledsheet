class SeasonsController < ApplicationController
  def index
    @seasons = Season.all
  end

  def show
    @season = Season.find(params[:id])
    @mens = Point.season_points(@season, 1)
    @womens = Point.season_points(@season, 2)
  end
end
