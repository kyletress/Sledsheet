class Admin::TimesheetsController < AdminController

  before_action :load_timesheet, only: [:edit, :update]
  before_action :set_track_time_zone, only: [:create, :update]
  before_action :set_track_time_zone_edit, only: [:edit]

  def index
  end

  def new
    @timesheet = PublicTimesheet.new
  end

  def edit
  end

  def update
    if @timesheet.update_attributes(timesheet_params)
      redirect_to admin_timesheets_path, success: 'Timesheet updated.'
    else
      render 'edit'
    end
  end

  def create
    @timesheet = PublicTimesheet.new(timesheet_params)
    @timesheet.user = current_user
    if @timesheet.save
      flash[:success] = "Timesheet created."
      redirect_to @timesheet
    else
      render 'new'
    end
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(:name, :nickname, :track_id, :circuit_id, :date, :race, :season_id, :pdf, :gender, :remote_pdf_url, :remove_pdf, :tweet, :status, :user_id)
  end

  def set_track_time_zone
    if params[:timesheet][:track_id]
      track = Track.find(params[:timesheet][:track_id])
      Time.zone = track.time_zone
    end
  end

  def set_track_time_zone_edit
    Time.zone = @timesheet.track.time_zone
  end

  def award_points
    @timesheet = Timesheet.friendly.find(params[:id])
    if @timesheet.race && @timesheet.complete
      @timesheet.award_points
    end
  end

  def load_Timesheet
    @timesheet = Timesheet.friendly.find(params[:id])
  end

end
