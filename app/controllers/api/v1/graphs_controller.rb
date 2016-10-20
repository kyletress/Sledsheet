class Api::V1::GraphsController < ApplicationController

  def create
    @timesheet = Timesheet.find(params[:timesheet_id])
    respond_to do |format|
      format.js
    end
  end

  def by_run
    @constant = Run.find(params[:constant])
    @series = params[:series]
  end

end
