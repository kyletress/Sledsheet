class ProfilesController < ApplicationController

  before_action :load_athlete
  before_action :correct_athlete, except: [:show]

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
    @profile = @athlete.build_profile(profile_params)
    if @profile.save
      redirect_to @athlete, notice: 'Profile Created!'
    else
      render 'new', notice: 'Could not be created at this time'
    end
  end

  def update
    @profile = @athlete.profile
    if @profile.update_attributes(profile_params)
      flash[:success] = "Profile has been updated."
      redirect_to @athlete
    else
      render 'edit'
    end
  end

  private

    def load_athlete
      @athlete = Athlete.find(params[:athlete_id])
    end

    def profile_params
      params.require(:profile).permit(:favorite_track, :favorite_curve, :location, :hometown, :twitter, :instagram, :facebook, :rallyme, :sled, :about)
    end

    def correct_athlete
      # determines the current user has admin rights
      @user = current_user
      redirect_to root_url unless @user.athlete == @athlete
    end

end
