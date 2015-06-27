class Timesheet < ActiveRecord::Base
  before_validation :name_timesheet
  before_save :assign_season

  belongs_to :track
  belongs_to :circuit
  belongs_to :season
  has_many :entries, dependent: :destroy
  has_many :athletes, through: :entries
  has_many :runs, through: :entries
  has_many :points

  validates :name, presence: true
  validates :date, presence: true
  validates :track_id, presence: true
  validates :circuit_id, presence: true
  validates :gender, presence: true

  enum gender: [:mixed, :men, :women]

  mount_uploader :pdf, PdfUploader

  default_scope -> { order('date DESC')}
  # scope :ordered -> { order('date DESC')}
  scope :races, -> { where(race: true)}
  #scope :olympics, ->() {include(:circuit).where('circuit.name' => "Olympic Winter Games")}


  def ranked_entries
    entries = Entry.find_by_sql(["SELECT *, rank() OVER (ORDER BY num_runs desc, total_time asc) FROM (SELECT Entries.id, Entries.timesheet_id, Entries.athlete_id, Entries.status, sum(Runs.finish) AS total_time, count(*) as num_runs FROM Entries INNER JOIN Runs ON (Entries.id = Runs.entry_id) GROUP BY Entries.id) AS FinalRanks WHERE timesheet_id = ?", self.id])
    ActiveRecord::Associations::Preloader.new.preload(entries, [:athlete, :runs])
    entries
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
        self.name = "#{track.name} #{circuit.name} #{if race then 'Race' else 'Training' end}" if track && circuit
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
end
