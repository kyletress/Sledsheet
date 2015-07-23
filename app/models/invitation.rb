class Invitation < ActiveRecord::Base
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  has_one :recipient, class_name: 'User'

  validates :recipient_email, presence: true
  validate :recipient_is_not_registered

  before_create :generate_token

  scope :waitlist, -> {where(sender_id: nil)}

  private

    def recipient_is_not_registered
      errors.add :recipient_email, 'Already registered' if User.find_by(email: recipient_email)
    end

    def generate_token
      self.token = SecureRandom.urlsafe_base64
    end

end
