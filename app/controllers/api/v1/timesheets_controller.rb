class Api::V1::TimesheetsController < ApplicationController

  def index
    @timesheets = Timesheet.all
  end

  def show
    @timesheet = Timesheet.includes(:entries).find(params[:id])
  end

end
