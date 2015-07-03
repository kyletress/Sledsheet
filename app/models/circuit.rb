class Circuit < ActiveRecord::Base
  has_many :timesheets
  has_many :points
  validates :name, presence: true
  default_scope -> { order('name ASC')}
end
