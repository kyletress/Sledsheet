class Admin::TracksController < AdminController
  
  def index
    @tracks = Track.all
  end
  
  def new
    @track = Track.new
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
    params.require(:track).permit(:name)
  end

end