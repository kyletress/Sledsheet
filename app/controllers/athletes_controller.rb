class AthletesController < ApplicationController

  before_action :admin_user, only: [:new, :edit, :update]

  def index
    @athletes = Athlete.all
    @popular = Athlete.popular
  end

  def show
    @athlete = Athlete.find(params[:id])
    @entries = @athlete.entries.includes(timesheet: :circuit).order('timesheets.date DESC')
  end

  def new
    @athlete = Athlete.new
  end

  def create
    @athlete = Athlete.new(athlete_params)
    if @athlete.save
      flash[:success] = "Athlete created."
      redirect_to @athlete
    else
      render 'new'
    end
  end

  def edit
    @athlete = Athlete.find(params[:id])
  end

  def update
    @athlete = Athlete.find(params[:id])
    if @athlete.update_attributes(athlete_params)
      flash[:success] = "Athlete updated."
      redirect_to @athlete
    else
      render 'edit'
    end
  end

  def destroy
    Athlete.find(params[:id]).destroy
    flash[:success] = "Athlete deleted."
    redirect_to athletes_url
  end

  private

    def athlete_params
      params.require(:athlete).permit(:first_name, :last_name, :country_code, :male, :avatar, :remote_avatar_url)
    end

end
