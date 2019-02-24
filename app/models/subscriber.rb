class Subscriber < ApplicationRecord
  extend Encryption

  attr_accessor :verification_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  before_create :create_verification_digest
  before_save { self.email = email.downcase }

  def email_successfully_verified!
    update_attribute(:email_verified, true)
    update_attribute(:verified_at, Time.zone.now)
  end

  def verification_token_valid?(token)
    return false if verification_digest.nil?
    BCrypt::Password.new(verification_digest).is_password?(token)
  end

  private

  def create_verification_digest
    self.verification_token  = Subscriber.new_token
    self.verification_digest = Subscriber.digest(verification_token)
  end
end
