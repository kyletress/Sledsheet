class Season < ActiveRecord::Base
  has_many :timesheets
  has_many :points
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_date, date: { before: :end_date }
  validate :start_date_must_be_july_1, :end_date_must_be_june_30

  default_scope -> { order('end_date DESC')}

  def name
    "#{start_date.year}/#{end_date.year} Season"
  end

  def short_name
    "#{start_date.year}-#{end_date.year}"
  end

  def start_date_must_be_july_1
    unless start_date.month == 7 && start_date.day == 1
      errors.add(:start_date, "must be July 1")
    end
  end

  def end_date_must_be_june_30
    unless end_date.month == 6 && end_date.day == 30
      errors.add(:end_date, "must be June 30")
    end
  end

  def self.current_season
    Season.first
  end

  def season_points
    points.group(:athlete).sum(:value)
  end

end
