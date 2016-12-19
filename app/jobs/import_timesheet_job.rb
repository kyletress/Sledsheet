class ImportTimesheetJob < ActiveJob::Base
  queue_as :default

  def perform(url, finish_td)
    t = TimesheetImport.new(url, finish_td)
    t.build_timesheet
  end
end
