class Timesheet < ActiveRecord::Base
  before_validation :name_timesheet
  before_save :assign_season

  belongs_to :track
  belongs_to :circuit
  belongs_to :season
  has_many :entries, dependent: :destroy
  has_many :athletes, through: :entries
  has_many :runs, through: :entries

  validates :name, presence: true
  validates :date, presence: true
  validates :track_id, presence: true
  validates :circuit_id, presence: true

  mount_uploader :pdf, PdfUploader

  default_scope -> { order('date DESC')}
  # scope :ordered -> { order('date DESC')}
  scope :races, -> { where(race: true)}
  #scope :olympics, ->() {include(:circuit).where('circuit.name' => "Olympic Winter Games")}


  def ranked_entries
    Entry.find_by_sql(["SELECT *, rank() OVER (ORDER BY total_time asc) FROM (SELECT Entries.id, Entries.timesheet_id, Entries.athlete_id, avg(Runs.finish) AS total_time FROM Entries INNER JOIN Runs ON (Entries.id = Runs.entry_id) GROUP BY Entries.id) AS FinalRanks WHERE timesheet_id = ?", self.id])
  end

  def comp_rank
    Run.find_by_sql(["with num_runs as (select entry_id, count(*) as num_runs from runs group by entry_id) select rank() over (order by num_runs desc, sum(r.finish) asc), r.entry_id, n.num_runs, sum(r.finish) as total_time from runs r inner join num_runs n on n.entry_id = r.entry_id group by r.entry_id, n.num_runs order by num_runs desc, total_time asc"])
  end

  # CTE for getting timesheet entries
  # with timesheet_entries as (select * from entries where timesheet_id = 17) select * from runs r inner join timesheet_entries t on r.entry_id = t.id group by r.entry_id, t.id, r.id;
  # Next get all the runs associated with these entries


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

  def assign_ranks
    # pull out entries and get the total time as a virtual table column.
    # Probably old. Remove?
    StandardCompetitionRankings.new(entries, :rank_by => :total_time, :sort_direction => :desc)
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
