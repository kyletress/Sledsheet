class Team < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true, length: { maximum: 50 }
  # validate :invitee_not_already_teammate

  def invitee_not_already_teammate
    # ?
  end

  def generate_team_code
     self.team_code = generate_secure_code
  end

  private

    def generate_secure_code
      SecureRandom.hex(4)
    end
end
