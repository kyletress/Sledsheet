class ProfilesController < ApplicationController

  before_filter :load_athlete

  def new
    @profile = @athlete.build_profile
  end

  def show
    @profile = @athlete.profile
  end

  def edit
    @profile = @athlete.profile
  end

  def create
    @profile = @athlete.profile.create(athlete_params)
    if @profile.save
      redirect_to @profile
    else
      render 'new', notice: 'Could not be created at this time'
    end
  end

  def update
  end

  private

    def load_athlete
      @athlete = Athlete.find(params[:athlete_id])
    end

    def athlete_params
      params.require(:profile).permit(:favorite_track, :favorite_curve, :location, :hometown, :twitter, :instagram, :facebook, :rallyme, :sled, :about)
    end

end
