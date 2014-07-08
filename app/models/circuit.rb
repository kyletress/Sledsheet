class Circuit < ActiveRecord::Base
  has_many :timesheets
  validates :name, presence: true
  default_scope -> { order('name ASC')}
end
