class Api::V1::AthletesController < ApplicationController
  def index
    if params[:q]
      @athletes = Athlete.search_by_full_name(params[:q])
    else
      @athletes = Athlete.all
    end
  end

  def show
    @athlete = Athlete.find(params[:id])
  end

end
