class Track < ActiveRecord::Base
  has_many :timesheets
  has_many :runs, through: :timesheets
  validates :name, presence: true
  default_scope -> { order('name ASC')}
  
  def track_record
    runs.order("finish ASC").first
  end
  
  def start_record
    runs.order("start ASC").first
  end
  
  def average_finish
    runs.average(:finish)
  end
  
end
