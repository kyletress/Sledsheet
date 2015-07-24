class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  after_destroy :destroy_invitation
  after_create :subscribe_user_to_mailing_list
  after_create :set_invitation_to_accepted

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  validates :invitation_id, presence: {message: 'must be present'}, uniqueness: true

  has_one :athlete
  has_many :sent_invitations, class_name: 'Invitation', foreign_key: 'sender_id'
  belongs_to :invitation

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def invitation_token
    # wont work. I don't have a invitation_id on my user model.
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

  private

    def subscribe_user_to_mailing_list
      SubscribeUserToMailingListJob.perform_later(self)
    end

    def destroy_invitation
      if invitation.present? && invitation_id != nil
        invite = Invitation.find(invitation_id)
        invite.destroy!
      end
    end

    def set_invitation_to_accepted
      invitation.update_column(:status, 1)
    end

end
