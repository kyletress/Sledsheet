class Admin::RunsController < AdminController

  def index
    @runs = Run.includes(entry: [:athlete, :timesheet]).unprocessed
  end

end
