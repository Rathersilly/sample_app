class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_create :create_activation_digest
  before_save { self.email.downcase!}  
  # also { self.email = email.downcase}   
  # which is same as before_save { self.email = self.email.downcase}
  # ie implicit self.  BUT implicit self cant be used on left side of assignment
  validates :name, presence: true, length: { maximum: 50 }
  # same as validates(:name, presence: true)
  VALID_EMAIL_REGEX = /\A[\w\-.\+]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                          format: { with: VALID_EMAIL_REGEX },
                          uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    # see RT 11.3 - send method
    digest = send("#{attribute}_digest")
    return false if digest.nil? # RT p432
    # see RT pg 420 blaze it for info.
    # also remember_token is not the same as @remember_token
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end


  private
    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
