class Athlete < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:first_name, :last_name]
  pg_search_scope :search_by_full_name, :against => [:first_name, :last_name]

  has_many :entries, dependent: :destroy
  has_many :timesheets, through: :entries
  has_many :points, dependent: :destroy
  has_one :profile, dependent: :destroy
  belongs_to :user
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :country_code, presence: true
  default_scope -> { order('last_name ASC')}

  mount_uploader :avatar, AvatarUploader

  enum gender: [:male, :female]

  # for the import function
  # scope :find_by_timesheet_name, ->(t_name) { where("lower(first_name) = ? AND lower(last_name) = ?", t_name.split(',').last.strip.downcase, t_name.split(',').first.downcase)}

  def self.find_by_timesheet_name(name)
    array = name.split(' ')
    if array.count > 2
      if array[1] === array[1].upcase
        last_name = "#{array[0]} #{array[1]}"
        first_name = "#{array[2]}"
      else
        last_name = "#{array[0]}"
        first_name = "#{array[1]} #{array[2]}"
      end
    else
      last_name = "#{array[0]}"
      first_name = "#{array[1]}"
    end
    Athlete.where("lower(first_name) = ? AND lower(last_name) = ?", first_name.downcase, last_name.downcase)
  end

  def self.find_or_create_by_timesheet_name(name, country, male)
    a = Athlete.find_by_timesheet_name(name)
    if a.count > 0
      a.first
    else
      # no results, create athlete.
      array = name.split(' ')
      if array.count > 2
        if array[1] === array[1].upcase
          last_name = "#{array[0]} #{array[1]}"
          first_name = "#{array[2]}"
        else
          last_name = "#{array[0]}"
          first_name = "#{array[1]} #{array[2]}"
        end
      else
        last_name = "#{array[0]}"
        first_name = "#{array[1]}"
      end
      country_code = ISO3166::Country.find_country_by_ioc(country.to_s).alpha2
      Athlete.create(first_name: first_name, last_name: last_name, country_code: country_code, male: if "men" then true else false end )
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

  def medal_count
    entries.where("bib <= 3").joins(:timesheet).where(timesheets: {race: true}).count
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

  def unclaimed?
    self.user_id.blank?
  end

  def world_rank
    points = Season.current_season.ranking_table(self.male)
    rank = points.select {|a| a.athlete_id == self.id }.first.try(:rank).to_i
  end

end
