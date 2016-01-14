class AthletesController < ApplicationController

  before_action :admin_user, only: [:new, :edit, :update]

  def index
    @athletes = Athlete.all
  end

  def show
    @athlete = Athlete.find(params[:id])
    @entries = @athlete.entries.includes(timesheet: :circuit).order('timesheets.date DESC').limit(10)
    @total_points = @athlete.season_points(Season.current_season).includes(:timesheet)
    @points = @athlete.season_points(Season.current_season).includes(:timesheet)
  end

  def new
    @athlete = Athlete.new
    @genders = Athlete.genders
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
    @genders = Athlete.genders
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

  def typeahead
    render json: Athlete.where('last_name ilike ?', "%#{params[:q]}%")
    # render json: Athlete.where('((athletes.first_name || ' ' || athletes.last_name) ILIKE ?) OR (athletes.first_name ILIKE ?) OR (athletes.last_name ILIKE ?)', "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")
  end

  def search
    render json: Athlete.where('last_name ilike ?', "%#{params[:q]}%")
  end

  private

    def athlete_params
      params.require(:athlete).permit(:first_name, :last_name, :country_code, :male, :gender, :avatar, :remote_avatar_url)
    end

end
