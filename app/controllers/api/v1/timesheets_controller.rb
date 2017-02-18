class Api::V1::TimesheetsController < ApplicationController

  def index
    @timesheets = Timesheet.all
  end

  def show
    @timesheet = Timesheet.friendly.find(params[:id])
    @entries = @timesheet.ranked_entries
    @runs = @timesheet.ranked_runs
  end

end
