class Admin::TemporaryTimesheetsController < ApplicationController

  def new
    @temp = TemporaryTimesheet.new
  end

  def create
    @temp = TemporaryTimesheet.new(temporary_timesheet_params)
    if @temp.save
      flash[:success] = "Timesheet sent for processing."
      redirect_to admin_temporary_timesheet_path(@temp)
    else
      render 'new'
    end
    # ImportTimesheetJob.perform_later(params[:url], params[:finish_td])
    # redirect_to timesheets_path, success: "Your import has started. We'll notify you when it's complete"
  end

  def index
  end

  def show
    @temp = TemporaryTimesheet.find(params[:id])
  end

  private

    def temporary_timesheet_params
      params.require(:temporary_timesheet).permit(:pdf)
    end

end
