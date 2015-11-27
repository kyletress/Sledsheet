class Entry < ActiveRecord::Base
  belongs_to :timesheet
  belongs_to :athlete
  has_many :runs, dependent: :destroy

  validates :athlete_id, :timesheet_id, presence: true
  validates :athlete_id, numericality: true

  acts_as_list :scope => :timesheet, :column => :bib

  enum status: [:ok, :dns, :dnf, :dsq]

  scope :medals, -> { where('position <= 3')} # and timesheet.race
  scope :podiums, -> { where ('position <= 6')}

  def date
    timesheet.date
  end

  def athlete_name
    athlete.try(:name)
  end

  def athlete_name=(name)
    self.athlete = Athlete.find_by(name: name)
  end

  def self.top_ten
    select('athlete_id, count(athlete_id)').
    where('bib <= 3'). # obviously needs to be rewritten
    group('athlete_id').
    order('count DESC').
    limit(10)
    # BOOM. returns array of relations. first.athlete.name, first.count.
  end

# necessary at the moment for PDF generation
  def total_time
    runs.sum(:finish)
  end

end
