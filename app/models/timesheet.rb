class Timesheet < ActiveRecord::Base
  before_validation :name_timesheet
  belongs_to :track
  belongs_to :circuit
  has_many :entries, dependent: :destroy
  has_many :athletes, through: :entries
  has_many :runs, through: :entries
  validates :name, presence: true
  validates :date, presence: true
  validates :track_id, presence: true
  validates :circuit_id, presence: true

  # default_scope -> { order('date DESC')}
  # scope :ordered -> { order('date DESC')}
  scope :races, -> { where(race: true)}
  #scope :olympics, ->() {include(:circuit).where('circuit.name' => "Olympic Winter Games")}
  

  def nice_date
    date.strftime("%B %d, %Y")
  end
  
  def best_run(heat)
    self.runs.where(position: heat).order("finish ASC").first 
  end
  
  def position_for(athlete)
    self.entries.where(athlete_id: athlete.id).first.position
  end

  private

    def name_timesheet
      self.name = "#{track.name} #{circuit.name} #{if race then 'Race' else 'Training' end}"
    end
end
