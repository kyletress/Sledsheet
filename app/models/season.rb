class Season < ActiveRecord::Base
  has_many :timesheets
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_date, date: { before: :end_date }

  # Start date must ALWAYS be July 1
  # End date must ALWAYS be June 30

  def name
    "#{start_date.year}/#{end_date.year} season"
  end
end
