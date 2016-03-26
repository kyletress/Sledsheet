class Heat < ActiveRecord::Base
  belongs_to :timesheet
  has_many :runs
end
