class Admin::TimesheetsController < AdminController

  before_action :load_timesheet, only: [:edit, :update]

  def index
    @timesheets = PublicTimesheet.all.includes(:season, :track)
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
    if @timesheet.save
      flash[:success] = "Timesheet created."
      redirect_to @timesheet
    else
      render 'new'
    end
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(:name, :time_zone, :latitude, :longitude)
  end

  def load_Timesheet
    @timesheet = Timesheet.friendly.find(params[:id])
  end

end
