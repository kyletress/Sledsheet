class TimesheetImportsController < ApplicationController

  def new
  end

  def create
    ImportTimesheetJob.perform_later(params[:url])
    redirect_to timesheets_path, success: "Your import has started. We'll notify you when it's complete"
  end
end
