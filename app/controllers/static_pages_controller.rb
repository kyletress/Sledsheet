class StaticPagesController < ApplicationController
  layout "home"

  def home
    @runs = Run.count
    @timesheets = Timesheet.count
    @athletes = Athlete.count
    @user = User.new
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def contact
  end

  def help
  end

end
