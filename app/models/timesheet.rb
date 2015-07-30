class Timesheet < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name]

  include Filterable

  before_validation :name_timesheet
  before_save :assign_season

  belongs_to :track
  belongs_to :circuit
  belongs_to :season
  has_many :entries, dependent: :destroy
  has_many :athletes, through: :entries
  has_many :runs, through: :entries
  has_many :points, dependent: :destroy

  validates :name, presence: true
  validates :date, presence: true
  validates :track_id, presence: true
  validates :circuit_id, presence: true
  validates :gender, presence: true

  enum gender: [:mixed, :men, :women]

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
    entries = Entry.find_by_sql(["SELECT *, total_time - first_value(total_time) over (partition by num_runs order by total_time asc) as time_behind, rank() OVER (ORDER BY num_runs desc, total_time asc) FROM (SELECT Entries.id, Entries.timesheet_id, Entries.athlete_id, Entries.status, sum(Runs.finish) AS total_time, count(*) as num_runs FROM Entries INNER JOIN Runs ON (Entries.id = Runs.entry_id) GROUP BY Entries.id) AS FinalRanks WHERE timesheet_id = ?", self.id])
    ActiveRecord::Associations::Preloader.new.preload(entries, [:athlete, :runs])
    entries
  end

  # What if I grabbed everything in one giant sql query and took out what I wanted on the view?

  def ranked_intermediates
    runs = Run.find_by_sql(["SELECT entry_id, start, (split2 - start) as int1, (split3 - split2) as int2, (split4 - split3) as int3, (split5 - split4) as int4, (finish - split5) as int5, finish FROM runs WHERE entry_id IN (SELECT id FROM entries WHERE timesheet_id = ?)", self.id])
    ActiveRecord::Associations::Preloader.new.preload(runs, [entry: [:athlete]])
    runs
  end

  def nice_date
    date.strftime("%B %d, %Y")
  end

  def machine_date
    date.strftime("%Y-%m-%d")
  end

  def pdf_name
    "#{machine_date}-#{track.name.parameterize}-#{circuit.name.parameterize}-#{if race then 'race' else 'training' end}"
  end

  def page_title
    "#{name} #{gender.capitalize} #{season.short_name}"
  end

  def best_run(heat)
    self.runs.where(position: heat).order("finish ASC").first
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
    end

    def assign_season
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
      if self.date.month > 6
        "#{self.date.strftime('%Y')}-#{(self.date + 1.year).strftime('%y')}"
      else
        "#{ (self.date - 1.year).strftime('%Y') }-#{self.date.strftime('%y')}"
      end
    end

end
