class CircuitsController < ApplicationController
  def index
    @circuits = Circuit.all
  end

  def show
    @circuit = Circuit.includes(:timesheets).find(params[:id])
    @mens = Point.circuit_points(Season.current_season, @circuit, true)
    @womens = Point.circuit_points(Season.current_season, @circuit, false)
  end
end
