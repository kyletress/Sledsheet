class Profile < ActiveRecord::Base
  belongs_to :athlete
  validates :about, length: { maximum: 140,
    too_long: "must be less than %{count} characters" }, allow_blank: true

end
