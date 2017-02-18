class Athlete < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:first_name, :last_name]
  pg_search_scope :search_by_full_name, :against => [:first_name, :last_name]

  extend FriendlyId
  friendly_id :name, use: :slugged

  after_create :create_google_alert

  has_many :entries, dependent: :destroy
  has_many :timesheets, through: :entries
  has_many :points, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_one :profile, dependent: :destroy
  belongs_to :user
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :country_code, presence: true
  default_scope -> { order('last_name ASC')}

  mount_uploader :avatar, AvatarUploader

  enum gender: {male: 0, female: 1, unprocessed: 2}

  def self.find_by_timesheet_name(name)
    array = name.split(' ')
    if array.count > 2
      if array[1] === array[1].upcase
        last_name = "#{array[0]} #{array[1]}"
        first_name = "#{array[2]}"
      else
        last_name = "#{array[0]}"
        first_name = "#{array[1]} #{array[2]}"
      end
    else
      last_name = "#{array[0]}"
      first_name = "#{array[1]}"
    end
    Athlete.where("lower(first_name) = ? AND lower(last_name) = ?", first_name.downcase, last_name.downcase)
  end

  def self.find_or_create_by_timesheet_name(name, country, gender)
    a = Athlete.find_by_timesheet_name(name)
    if a.count > 0
      a.first
    else
      # no results, create athlete.
      array = name.split(' ')
      if array.count > 2
        if array[1] === array[1].upcase
          last_name = "#{array[0]} #{array[1]}"
          first_name = "#{array[2]}"
        else
          last_name = "#{array[0]}"
          first_name = "#{array[1]} #{array[2]}"
        end
      else
        last_name = "#{array[0]}"
        first_name = "#{array[1]}"
      end
      country_code = ISO3166::Country.find_country_by_ioc(country.to_s).alpha2
      Athlete.create(first_name: first_name, last_name: last_name.titleize, country_code: country_code, gender: gender)
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def timesheet_name
    "#{last_name.upcase}, #{first_name}"
  end

  def avatar_name
    "#{last_name.parameterize}-#{first_name.parameterize}"
  end

  def is_olympian?
    c = Circuit.find_by_name('Olympic Winter Games')
    t = timesheets.where(circuit: c)
    t.count > 0 ? true : false
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def timesheet_country
    country = ISO3166::Country[country_code]
    country.ioc
  end

  def medal_count # Needs to be rewritten to use rank instead of bib.
    entries.where("bib <= 3").joins(:timesheet).where(timesheets: {race: true}).count
  end

  def points_for(season)
    points.sum(:value)
  end

  def season_points(season)
    # don't hard code the count. Should be based off WC races
    points.where('season_id = ?', season.id).order('value DESC').limit(season.world_cup_race_count(self.gender))
  end

  def current_season_points
    season_points(Season.current_season)
  end

  def season_point_total(season)
    season_points(season).pluck(:value).sum
  end

  def unclaimed?
    self.user_id.blank?
  end

  def world_rank(season)
    points = season.ranking_table(self.male)
    rank = points.select {|a| a.athlete_id == self.id }.first.try(:rank).to_i
  end

  def season_positions(season)
    # provides a list of points and their associated position for an athlete and season
    points = Point.find_by_sql(["select name, rank, points.id, points.timesheet_id, points.value from (
      select *, rank() over (partition by timesheet_id order by runs_count desc, total_time asc) from (
        select entries.id, entries.athlete_id, entries.timesheet_id, entries.runs_count, timesheets.name, timesheets.date, timesheets.id, sum(runs.finish) as total_time from entries inner join timesheets on entries.timesheet_id = timesheets.id left join runs on entries.id = runs.entry_id where timesheets.season_id = ? group by entries.id, timesheets.name, timesheets.id order by timesheets.name
      ) as initialranks
    ) as finalranks inner join points on finalranks.athlete_id = points.athlete_id and finalranks.timesheet_id = points.timesheet_id where finalranks.athlete_id = ? order by value desc;", season.id, self.id])
    ActiveRecord::Associations::Preloader.new.preload(points, :timesheet)
    points
  end

  def medal_count_by_circuit
  query =  "select circuit, count(circuit) from (
      select finalranks.name, rank, circuits.nickname as circuit from (
        select *, rank() over (partition by timesheet_id order by runs_count desc, total_time asc) from (
          select entries.id, entries.athlete_id, entries.timesheet_id, entries.runs_count, timesheets.name, timesheets.id, timesheets.circuit_id, sum(runs.finish) as total_time from entries inner join timesheets on entries.timesheet_id = timesheets.id left join runs on entries.id = runs.entry_id where (timesheets.race = true and timesheets.visibility = 1) group by entries.id, timesheets.name, timesheets.id order by timesheets.name
        ) as initialranks
      ) as finalranks inner join circuits on finalranks.circuit_id = circuits.id where finalranks.athlete_id = 5 and finalranks.rank <= 3
    ) as medalcount group by circuit order by count desc;"
    ActiveRecord::Base.connection.execute(query).to_json
  end

  def self.career_medal_table
    athletes = Athlete.find_by_sql([
    "SELECT athlete_id as id,
    first_name,
    last_name,
      sum(count) as TOTAL_MEDALS,
      sum(case when circuit = 'OWG' then count else 0 end) OWG_TOTAL,
      sum(case when circuit = 'OWG' AND rank = 1 then count else 0 end) OWG_GOLD,
      sum(case when circuit = 'OWG' AND rank = 2 then count else 0 end) OWG_SILVER,
      sum(case when circuit = 'OWG' AND rank = 3 then count else 0 end) OWG_BRONZE,
      sum(case when circuit = 'WCh' then count else 0 end) WCH_TOTAL,
      sum(case when circuit = 'WCh' AND rank = 1 then count else 0 end) WCH_GOLD,
      sum(case when circuit = 'WCh' AND rank = 2 then count else 0 end) WCH_SILVER,
      sum(case when circuit = 'WCh' AND rank = 3 then count else 0 end) WCH_BRONZE,
      sum(case when circuit = 'WC' then count else 0 end) WC_TOTAL,
      sum(case when circuit = 'WC' AND rank = 1 then count else 0 end) WC_GOLD,
      sum(case when circuit = 'WC' AND rank = 2 then count else 0 end) WC_SILVER,
      sum(case when circuit = 'WC' AND rank = 3 then count else 0 end) WC_BRONZE,
      sum(case when circuit = 'IC' then count else 0 end) IC_TOTAL,
      sum(case when circuit = 'IC' AND rank = 1 then count else 0 end) IC_GOLD,
      sum(case when circuit = 'IC' AND rank = 2 then count else 0 end) IC_SILVER,
      sum(case when circuit = 'IC' AND rank = 3 then count else 0 end) IC_BRONZE,
      sum(case when circuit = 'EC' then count else 0 end) EC_TOTAL,
      sum(case when circuit = 'EC' AND rank = 1 then count else 0 end) EC_GOLD,
      sum(case when circuit = 'EC' AND rank = 2 then count else 0 end) EC_SILVER,
      sum(case when circuit = 'EC' AND rank = 3 then count else 0 end) EC_BRONZE,
      sum(case when circuit = 'NAC' then count else 0 end) NAC_TOTAL,
      sum(case when circuit = 'NAC' AND rank = 1 then count else 0 end) NAC_GOLD,
      sum(case when circuit = 'NAC' AND rank = 2 then count else 0 end) NAC_SILVER,
      sum(case when circuit = 'NAC' AND rank = 3 then count else 0 end) NAC_BRONZE

    from (
    select athlete_id, athletes.first_name, athletes.last_name, rank, count(*), circuits.nickname as circuit from (
      select *, rank() over (partition by timesheet_id order by runs_count desc, total_time asc) from (
        select entries.id, entries.athlete_id, entries.timesheet_id, entries.runs_count, timesheets.name, timesheets.id, timesheets.circuit_id, sum(runs.finish) as total_time from entries inner join timesheets on entries.timesheet_id = timesheets.id left join runs on entries.id = runs.entry_id where (timesheets.race = true and timesheets.visibility = 1) group by entries.id, timesheets.name, timesheets.id order by timesheets.name
      ) as initialranks
    ) as finalranks inner join athletes on finalranks.athlete_id = athletes.id inner join circuits on finalranks.circuit_id = circuits.id where finalranks.rank <= 3  group by athlete_id, athletes.first_name, athletes.last_name, rank, circuits.nickname order by athlete_id, circuit, rank asc
    ) as test group by athlete_id, first_name, last_name order by TOTAL_MEDALS desc;"])
    athletes
  end

  private

    def create_google_alert
      return if ENV['REVIEW_ENVIRONMENT'] == 'true'
      CreateGoogleAlertJob.perform_later(self)
    end


end

__END__
