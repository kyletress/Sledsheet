class ImportTimesheetJob < ActiveJob::Base
  queue_as :default

  def perform(url)
    t = TimesheetImport.new(url)
    t.build_timesheet
  end
end
