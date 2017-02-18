class Admin::TracksController < AdminController

  before_action :load_track, only: [:edit, :update]

  def index
    @tracks = Track.all
  end

  def new
    @track = Track.new
  end

  def edit
  end

  def update
    if @track.update_attributes(track_params)
      redirect_to admin_tracks_path, success: 'Track updated.'
    else
      render 'edit'
    end
  end

  def create
    @track = Track.new(track_params)
    if @track.save
      flash[:success] = "Track created."
      redirect_to @track
    else
      render 'new'
    end
  end

  private

  def track_params
    params.require(:track).permit(:name, :time_zone, :latitude, :longitude)
  end

  def load_track
    @track = Track.friendly.find(params[:id])
  end

end
