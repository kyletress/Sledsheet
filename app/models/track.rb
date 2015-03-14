class Track < ActiveRecord::Base
  has_many :timesheets
  has_many :runs, through: :timesheets
  validates :name, presence: true
  default_scope -> { order('name ASC')}
  
  def track_record
    # override the default scope
    runs.reorder("finish ASC").first
  end
  
  def start_record
    runs.reorder("start ASC").first
  end
  
  def average_finish
    runs.average(:finish)
  end
  
end
