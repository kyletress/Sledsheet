class Circuit < ActiveRecord::Base
  has_many :timesheets
  has_many :points
  validates :name, presence: true
  default_scope -> { order('name ASC')}

  def circuit_points
    # need to scope this to a season
    points = Point.find_by_sql(['select athlete_id, sum(value) as total_points from points where circuit_id = ? group by athlete_id order by total_points desc', self.id])
    ActiveRecord::Associations::Preloader.new.preload(points, :athlete)
    points
  end

end
