class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  after_create :subscribe_user_to_mailing_list

  # after_create :sync_shared_timesheets

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  has_secure_password

  validates :password, length: { minimum: 6 }

  has_many :timesheets
  has_one :athlete
  has_many :shared_timesheets, dependent: :destroy

  has_many :being_shared_timesheets, class_name: "SharedTimesheet", foreign_key: "shared_user_id", dependent: :destroy # returns SharedTimesheet records

  has_many :shared_timesheets_by_others, through: :being_shared_timesheets, source: :timesheet # returns actual timesheet records. source of N+1?

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Activates an account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email
  def send_activation_email
    return if ENV['REVIEW_ENVIRONMENT'] == 'true'
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hour.ago
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def has_share_access?(timesheet)
    # user created this timesheet
    return true if self.timesheets.include?(timesheet)
    # shared by others
    return true if self.shared_timesheets_by_others.include?(timesheet)
    return false
  end

  private

    def subscribe_user_to_mailing_list
      return if ENV['REVIEW_ENVIRONMENT'] == 'true'
      if Rails.env.production? && ENV['MAILING_LIST_ENABLED'] == 'true'
        SubscribeUserToMailingListJob.perform_later(self)
      end
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def downcase_email
      self.email = email.downcase
    end

end
