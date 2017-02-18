class CircuitsController < ApplicationController
  def index
    @circuits = Circuit.all
  end

  def show
    @circuit = Circuit.friendly.find(params[:id])
    @mens = Point.circuit_points(Season.current_season, @circuit, 0)
    @womens = Point.circuit_points(Season.current_season, @circuit, 1)
  end
end
