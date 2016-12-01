class TimesheetImportsController < ApplicationController

  def new
    @timesheet = Timesheet.find(params[:id])
  end

  def create
    @timesheet = Timesheet.find(params[:id])
    @import = TimesheetImport.new(params[:url]) # import from the given URL
    @timesheet.build # or whatever, with this data... (@import.build_timesheet(@timesheet))
  end


end
