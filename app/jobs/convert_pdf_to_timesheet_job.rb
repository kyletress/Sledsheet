class ConvertPdfToTimesheetJob < ApplicationJob
  queue_as :default

  def perform(temporary_timesheet)
    response = Pdftable.client.convert(ActiveStorage::Blob.service.send(:path_for, temporary_timesheet.pdf.key), format: 'csv')
    temporary_timesheet.update(raw_data: response)
    # clean_response = TemporaryTimesheet.clean(response)
    # temporary_timesheet.update(clean_data: clean)
    # might need to convert this into some kind of json object 
  end
end
