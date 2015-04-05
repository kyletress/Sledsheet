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

  default_scope -> { order('date DESC')}
  # scope :ordered -> { order('date DESC')}
  scope :races, -> { where(race: true)}
  #scope :olympics, ->() {include(:circuit).where('circuit.name' => "Olympic Winter Games")}
  
  ### whaaaaaaaa?
  def self.with_rank
    select("timesheets.*, (created_at - updated_at) as duration").limit(3)
  end
  
  def ranked_entries
    # postgres is awesome
    # need to scope this under @timesheet
    # remove the partition and from clause if you want
    Entry.find_by_sql(["SELECT *, rank() OVER (ORDER BY total_time asc) FROM (SELECT Entries.id, Entries.timesheet_id, avg(Runs.finish) AS total_time FROM Entries INNER JOIN Runs ON (Entries.id = Runs.entry_id) GROUP BY Entries.id) AS FinalRanks WHERE timesheet_id = ?", self.id])
  end
  
  def nice_date
    date.strftime("%B %d, %Y")
  end
  
  def best_run(heat)
    self.runs.where(position: heat).order("finish ASC").first 
  end
  
  def position_for(athlete)
    self.entries.where(athlete_id: athlete.id).first.position
  end
  
  def assign_ranks
    # pull out entries and get the total time as a virtual table column. 
    StandardCompetitionRankings.new(entries, :rank_by => :total_time, :sort_direction => :desc)
  end

  private

    def name_timesheet
      self.name = "#{track.name} #{circuit.name} #{if race then 'Race' else 'Training' end}"
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
