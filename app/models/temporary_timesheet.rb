class TemporaryTimesheet < ApplicationRecord
  has_one_attached :pdf

  after_create :convert_pdf_to_timesheet

  def clean_response_data
    raw_data.gsub!('"','') # remove quotes around names 
    raw_data.gsub!(/\(\d*\)/,'') # remove split ranks
  end

  private

    def convert_pdf_to_timesheet
      ConvertPdfToTimesheetJob.perform_later(self)
    end

end
