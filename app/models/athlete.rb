class Athlete < ActiveRecord::Base
  has_many :entries
  has_many :timesheets, through: :entries
  has_many :points
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :country_code, presence: true
  default_scope -> { order('last_name ASC')}

  mount_uploader :avatar, AvatarUploader

  # for the import function
  scope :find_by_timesheet_name, ->(t_name) { where("lower(first_name) = ? AND lower(last_name) = ?", t_name.split(',').last.strip.downcase, t_name.split(',').first.downcase)}

  def self.find_or_create_by_timesheet_name(name, country, male)
    a = Athlete.find_by_timesheet_name(name)
    if a.count > 0
      a.first
    else
      first_name = name.split(',').last.strip.capitalize
      last_name = name.split(',').first.capitalize
      country_code = ISO3166::Country.find_country_by_ioc(country.to_s).alpha2
      Athlete.create(first_name: first_name, last_name: last_name, country_code: country_code, male: male)
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def timesheet_name
    "#{last_name.upcase}, #{first_name}"
  end

  def avatar_name
    "#{last_name.parameterize}-#{first_name.parameterize}"
  end

  def is_olympian?
    c = Circuit.find_by_name('Olympic Winter Games')
    t = timesheets.where(circuit: c)
    t.count > 0 ? true : false
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def timesheet_country
    country = ISO3166::Country[country_code]
    country.ioc
  end

  # Vestigial. No longer use position.
  def medal_count
    entries.where("position <= 3 ").count
  end

  def points_for(season)
    points.sum(:value)
  end

  def season_points(season)
    points.where('season_id = ?', season.id).order('value DESC').limit(8)
  end

  def season_point_total(season)
    season_points(season).pluck(:value).sum
  end

  def self.popular
    find([1, 5, 2, 211, 3, 64])
  end

end
