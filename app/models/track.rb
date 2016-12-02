class Track < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name]

  has_many :timesheets
  has_many :runs, through: :timesheets
  validates :name, presence: true
  default_scope -> { order('name ASC')}

  def track_record
    runs.reorder("finish ASC").where("finish > 0").first
  end

  def track_record_women
    runs.joins(entry: :athlete).where(athletes: {gender: 1}).order(finish: :asc).first.try(:finish)
  end

  def track_record_men
    runs.joins(entry: :athlete).where(athletes: {gender: 0}).order(finish: :asc).first.try(:finish)
  end

  def start_record_men
    runs.joins(entry: :athlete).where(athletes: {gender: 0}).order(start: :asc).first.try(:start)
  end

  def start_record_women
    runs.joins(entry: :athlete).where(athletes: {gender: 1}).order(start: :asc).first.try(:start)
  end

  def start_record
    runs.reorder("start ASC").where("start > 0").first
  end

  def average_finish
    runs.average(:finish).to_i
  end

  def weather_forecast
    Rails.cache.fetch("#{cache_key}/five_day_forecast", expires_in: 24.hours) do
      forecast = ForecastIO.forecast(latitude, longitude)
    end
  end

end
