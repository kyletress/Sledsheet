class StaticPagesController < ApplicationController

  def home
    @runs = Run.count
    @timesheets = Timesheet.count
    @athletes = Athlete.count
    @articles = Article.limit(5)
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
