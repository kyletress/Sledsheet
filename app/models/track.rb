class Track < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name]

  has_many :timesheets
  has_many :runs, through: :timesheets
  validates :name, presence: true
  default_scope -> { order('name ASC')}

  def track_record
    runs.reorder("finish ASC").first
  end

  def track_record_women
    runs.joins(entry: :athlete).where(athletes: {gender: 1}).first.try(:finish)
  end

  def track_record_men
    runs.joins(entry: :athlete).where(athletes: {gender: 0}).first.try(:finish)
  end

  def start_record_men
    runs.joins(entry: :athlete).where(athletes: {gender: 0}).first.try(:finish)
  end

  def start_record_women
    runs.joins(entry: :athlete).where(athletes: {gender: 1}).first.try(:start)
  end

  def start_record
    runs.reorder("start ASC").first
  end

  def average_finish
    runs.average(:finish)
  end

end
