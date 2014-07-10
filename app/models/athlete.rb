class Athlete < ActiveRecord::Base
  has_many :entries
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :country_code, presence: true
  default_scope -> { order('last_name ASC')}

  # Can I add a uniqueness validation on full name? Prevent duplicates.
  def name
    "#{first_name} #{last_name}"
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def timesheet_country
    country = ISO3166::Country[country_code]
    country.ioc
  end

end
