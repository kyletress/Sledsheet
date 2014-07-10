class Entry < ActiveRecord::Base
  belongs_to :timesheet
  belongs_to :athlete

  validates :athlete_id, :timesheet_id, presence: true

end
