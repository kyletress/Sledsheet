class Admin::TimesheetImportsController < AdminController

  def new
  end

  def create
    ImportTimesheetJob.perform_later(params[:url], params[:finish_td])
    redirect_to timesheets_path, success: "Your import has started. We'll notify you when it's complete"
  end
end
