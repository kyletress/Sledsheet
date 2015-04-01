class Entry < ActiveRecord::Base
  belongs_to :timesheet
  belongs_to :athlete
  has_many :runs, dependent: :destroy

  validates :athlete_id, :timesheet_id, presence: true

  acts_as_list :scope => :timesheet
  
  def total_time
    runs.sum(:finish)
  end
  
  def date
    timesheet.date
  end
  
end
