class StaticPagesController < ApplicationController
  def home
    @runs = Run.count
    @timesheets = Timesheet.count
    @athletes = Athlete.count
  end

  def about
  end
end
