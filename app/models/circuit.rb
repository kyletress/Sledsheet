class Circuit < ActiveRecord::Base
  validates :name, presence: true
  default_scope -> { order('name ASC')}
end
