class PointsController < ApplicationController
  before_action :find_timesheet

  def index
    @points = @timesheet.points.includes(:athlete)
  end

  def create
    @timesheet.award_points
    redirect_to timesheet_points_path(@timesheet)
  end

  private

  def find_timesheet
    @timesheet = Timesheet.find(params[:timesheet_id])
  end

end
