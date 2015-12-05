class Api::V1::SeasonsController < ApplicationController

  def index
    @seasons = Season.all
  end

  def show
    @season = Season.find(params[:id])
    @mens_rankings = @season.rankings(0)
    @womens_rankings = @season.rankings(1)
  end

end
