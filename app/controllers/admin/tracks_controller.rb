class Admin::TracksController < AdminController

  def index
    @tracks = Track.all
  end

  def new
    @track = Track.new
  end

  def edit
    @track = Track.find(params[:id])
  end

  def update
    @track = Track.find(params[:id])
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
    params.require(:track).permit(:name, :time_zone)
  end

end
