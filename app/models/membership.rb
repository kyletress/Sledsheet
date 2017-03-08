class Membership < ApplicationRecord
  belongs_to :team
  belongs_to :user
  validates :user_id, uniqueness: { scope: :team_id }
  # should probably add a constraint on the database too. 
end
