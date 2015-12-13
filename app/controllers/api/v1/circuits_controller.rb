class Api::V1::CircuitsController < ApplicationController
  def index
    @circuits = Circuit.all
  end

  def show
    @circuit = Circuit.find(params[:id])
    if params[:gender] == 'men'
      @rankings = @circuit.current_rankings(0)
    elsif params[:gender] == 'women'
      @rankings = @circuit.current_rankings(1)
    end
  end

end
