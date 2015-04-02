class Entry < ActiveRecord::Base
  belongs_to :timesheet
  belongs_to :athlete
  has_many :runs, dependent: :destroy

  validates :athlete_id, :timesheet_id, presence: true

  acts_as_list :scope => :timesheet
  
  scope :medals, -> { where('position <= 3')} # and timesheet.race
  scope :podiums, -> { where ('position <= 6')}
  
  def total_time
    runs.sum(:finish)
  end
  
  def date
    timesheet.date
  end
  
  def self.top_ten
    
  end
  
  def self.top_ten
    select('athlete_id, count(athlete_id)').
    where('position <= 3').
    group('athlete_id').
    order('count DESC').
    limit(10)
    # BOOM. returns array of relations. first.athlete.name, first.count.
  end
  
end
