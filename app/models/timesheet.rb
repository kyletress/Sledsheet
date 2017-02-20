class Timesheet < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name]

  include Filterable

  extend FriendlyId
  friendly_id :pdf_name, use: :slugged

  before_validation :name_timesheet
  before_save :assign_season
  after_save :get_timesheet_weather, if: :timesheet_date_changed?

  # after delete should remove GetWeatherJob from Redis if it exists

  belongs_to :user
  belongs_to :track
  belongs_to :circuit
  belongs_to :season
  has_many :entries, dependent: :destroy
  has_many :athletes, through: :entries
  has_many :runs, through: :heats
  has_many :runs, through: :entries # :heats, eventually? maybe doesn't matter
  has_many :points, dependent: :destroy

  validates :name, presence: true
  validates :date, presence: true
  validates :track_id, presence: true
  validates :circuit_id, presence: true
  validates :gender, presence: true

  enum gender: {men: 0, women: 1, mixed: 2}
  enum status: {open: 0, complete: 1} # live
  # only admins can add public timesheets
  enum visibility: {personal: 0, general: 1} # draft, hidden?

  mount_uploader :pdf, PdfUploader

  default_scope -> { order('date DESC')}
  # scope :ordered -> { order('date DESC')}
  # Filter Scopes
  scope :race, -> { where(race: true)}
  scope :type, -> (boolean) { where race: boolean }
  scope :track, -> (track_id) { where track_id: track_id }
  scope :circuit, -> (circuit_id) { where circuit_id: circuit_id }
  # Already scoped Timesheet.men, etc. How to use that?
  scope :gender, -> (gender) { where gender: gender }
  scope :season, -> (season_id) { where season_id: season_id }


  def ranked_entries

    entries = Entry.find_by_sql(["SELECT *, total_time - first_value(total_time) over (partition by runs_count order by total_time asc) as time_behind, rank() OVER (ORDER BY runs_count desc, total_time asc) FROM (SELECT Entries.id, Entries.timesheet_id, Entries.athlete_id, Entries.status, Entries.bib, Entries.runs_count, sum(Runs.finish) AS total_time FROM Entries LEFT JOIN Runs ON (Entries.id = Runs.entry_id) GROUP BY Entries.id) AS FinalRanks WHERE timesheet_id = ? ORDER BY rank, total_time asc, bib asc", self.id])
    ActiveRecord::Associations::Preloader.new.preload(entries, [:athlete, :runs])
    entries
    # add WHERE Entries.status = '0' before the group by to limit to OK entries. Needs work.
  end

  def ranked_runs
    runs = Run.find_by_sql([
      "SELECT *,
      rank() OVER (PARTITION BY position ORDER BY start ASC)  AS start_rank,
      rank() OVER (PARTITION BY position ORDER BY split2 ASC) AS split2_rank,
      rank() OVER (PARTITION BY position ORDER BY split3 ASC) AS split3_rank,
      rank() OVER (PARTITION BY position ORDER BY split4 ASC) AS split4_rank,
      rank() OVER (PARTITION BY position ORDER BY split5 ASC) AS split5_rank,
      rank() OVER (PARTITION BY position ORDER BY finish ASC) AS finish_rank
      FROM runs
      WHERE runs.entry_id IN(#{self.entries.ids.map{|x| x.inspect}.join(', ')})"])
      ActiveRecord::Associations::Preloader.new.preload(runs, { entry: :athlete })
      runs
  end

  def nice_date
    date.in_time_zone(track.time_zone).strftime("%B #{date.day.ordinalize}, %Y %-l:%M%P")
  end

  def machine_date
    date.strftime("%Y-%m-%d")
  end

  def shortname
    # probably need to turn this into an attribute to avoid N+1
    "#{track.name} #{circuit.nickname} #{season.short_name}"
  end

  def short_name
    "#{track.name} #{circuit.nickname}"
  end

  def pdf_name
    "#{machine_date}-#{track.name.parameterize}-#{circuit.name.parameterize}-#{if race then 'race' else 'training' end}-#{gender}"
  end

  def page_title
    "#{name} #{gender.capitalize} #{season.short_name}"
  end

  def best_run(position)
    runs.where(position: position).order(finish: :asc).first
  end

  def best_runs
    Run.select("distinct on (position) id, entry_id, position, start, split2, split3, split4, split5, finish").where(entry: entries.ids).order(position: :asc, finish: :asc)
  end

  def position_for(athlete)
    self.entries.where(athlete_id: athlete.id).first.bib
  end

  def award_points
    ranked_entries.each do |entry|
      if entry.ok?
        p = Point.new(athlete: entry.athlete, timesheet: self, circuit: self.circuit, season: self.season)
        p.value = p.calculate_points_for(self.circuit.name, entry.rank)
        p.save
      end
    end
  end

  def points_eligible
    race? && complete?
  end

  private

    def name_timesheet
      self.name = "#{track.name} #{circuit.name} #{if race then 'Race' else 'Training' end} #{season_name} #{gender.capitalize}" if track && circuit
      # add an attribute below for this
      # self.nickname = "#{track.name} #{circuit.nickname} #{if race then 'Race' end} #{season.short_name}" if track && circuit
    end

    def assign_season
      return if self.date.nil?
      month = self.date.month
      if month > 6 # first half of season (oct 2014)
        end_date = Date.new(self.date.year + 1, 6, 30) # date is June 30, 2015
        start_date = Date.new(self.date.year, 7, 1) # July 1 2014
        self.season = Season.create_with(end_date: end_date).find_or_create_by(start_date: start_date)
      else # second half of season timesheet (Jan 2015)
        end_date = Date.new(self.date.year, 6, 30) # date is June 30, 2015
        start_date = Date.new(self.date.year - 1, 7, 1) # July 1 2014
        self.season = Season.create_with(end_date: end_date).find_or_create_by(start_date: start_date)
      end
    end

    def season_name
      return if self.date.nil?
      if self.date.month > 6
        "#{self.date.strftime('%Y')}-#{(self.date + 1.year).strftime('%y')}"
      else
        "#{ (self.date - 1.year).strftime('%Y') }-#{self.date.strftime('%y')}"
      end
    end

    def get_timesheet_weather
      if self.date < Date.today
        GetTimesheetWeatherJob.perform_later(self)
      else
        GetTimesheetWeatherJob.set(wait_until: self.date).perform_later(self)
      end
    end

    def timesheet_date_changed?
      self.date_changed?
    end

end
