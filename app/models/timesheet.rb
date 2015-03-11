class Timesheet < ActiveRecord::Base
  before_validation :name_timesheet
  belongs_to :track
  belongs_to :circuit
  has_many :entries, dependent: :destroy
  has_many :runs, through: :entries
  validates :name, presence: true
  validates :date, presence: true
  validates :track_id, presence: true
  validates :circuit_id, presence: true

  default_scope -> { order('date DESC')}

  def nice_date
    date.strftime("%B %d, %Y")
  end
  
  def best_run(heat)
    self.runs.where(position: heat).order("finish ASC").first 
  end

  private

    def name_timesheet
      self.name = "#{track.name} #{circuit.name} #{if race then 'Race' else 'Training' end}"
    end
end
