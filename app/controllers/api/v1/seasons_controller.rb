class Api::V1::SeasonsController < ApplicationController

  def index
    @seasons = Season.all
  end

  def show
    @season = Season.find(params[:id])
    @men = @season.rankings(0)
    @women = @season.rankings(1)
    @rankings = @men + @women
  end

  def men
    @season = Season.find(params[:id])
    @rankings = @season.rankings(0)
  end

  def women
    @season = Season.find(params[:id])
    @rankings = @season.rankings(1)
  end

  def athletes
    @season = Season.find(params[:id])
    @athlete = Athlete.find(params[:athlete_id])
    @points = @athlete.season_positions(@season)
  end

end
