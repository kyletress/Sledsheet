class Season < ActiveRecord::Base
  extend FriendlyId
  friendly_id :short_name, use: :slugged

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
    "#{start_date.year}-#{end_date.strftime('%y')}"
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
    if Season.first.timesheets.race.present?
      Season.first
    else
      Season.where('extract(year from end_date) = ?', Date.today.year).first
    end
  end

  def season_points
    # doesn't distinguish between men and women.
    points.group(:athlete).sum(:value)
  end

  def ranking_table(gender)
    points = Point.find_by_sql(["SELECT athlete_id, total_points, rank() over (order by total_points desc) FROM (SELECT athlete_id, sum(value) as total_points FROM (SELECT row_number() OVER (partition by athlete_id ORDER BY value DESC) as r, p.* FROM points p where season_id = ?) x WHERE x.r <= 8 GROUP BY athlete_id ORDER BY total_points DESC) as season_points INNER JOIN athletes on athlete_id = athletes.id WHERE male = ? ORDER BY total_points DESC", self, gender])
  end

  def rankings(gender)
    # How many WC races are there this season?
    count = Timesheet.where(circuit: 1, season: self, race: true, gender: gender, status: 1).count
    points = Point.find_by_sql(["SELECT athlete_id, total_points, rank() over (order by total_points desc) as world_rank, rank() over (partition by country_code order by total_points desc) as nation_rank FROM (SELECT athlete_id, sum(value) as total_points FROM (SELECT row_number() OVER (partition by athlete_id ORDER BY value DESC) as r, p.* FROM points p where season_id = ?) x WHERE x.r <= 8 AND x.r <= ? GROUP BY athlete_id ORDER BY total_points DESC) as season_points INNER JOIN athletes on athlete_id = athletes.id WHERE gender = ? ORDER BY total_points DESC", id, count, gender])
    ActiveRecord::Associations::Preloader.new.preload(points, :athlete)
    points
  end

  def world_cup_race_count(gender)
    Timesheet.where(circuit: 1, season: self, race: true, gender: gender, status: 1).count
  end


end
