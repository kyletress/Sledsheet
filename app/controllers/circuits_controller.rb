class CircuitsController < ApplicationController
  def index
    @circuits = Circuit.all
  end

  def show
    @circuit = Circuit.includes(:timesheets).find(params[:id])
    @points = @circuit.circuit_points
  end
end
