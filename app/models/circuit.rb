class Circuit < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name]
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :timesheets
  has_many :points
  validates :name, presence: true
  default_scope -> { order('name ASC')}

  def current_rankings(gender)
    points = Point.find_by_sql(["SELECT athlete_id, total_points, rank() over (order by total_points desc) FROM (SELECT athlete_id, sum(value) as total_points FROM (SELECT row_number() OVER (partition by athlete_id ORDER BY value DESC) as r, p.* FROM points p where season_id = ? and circuit_id = ?) x WHERE x.r <= 8 GROUP BY athlete_id ORDER BY total_points DESC) as season_points INNER JOIN athletes on athlete_id = athletes.id WHERE gender = ? ORDER BY total_points DESC", Season.current_season, self.id, gender])
    ActiveRecord::Associations::Preloader.new.preload(points, :athlete)
    points
  end
end
