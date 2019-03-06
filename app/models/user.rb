class User < ApplicationRecord
  extend Encryption

  validates :name, presence: true, length: { maximum: 255 }
  validates :phone, format: { with: /\A\d{10}\z/, message: "should be a 10-digit number" }
  validates :phone, uniqueness: true

  has_one :brand, foreign_key: :owner_id, dependent: :destroy

  def phone_successfully_verified!
    update_attribute(:phone_verified, true)
  end

  def remember
    token = User.new_token
    update_attribute(:remember_digest, User.digest(token))
    token
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(token)
    User.authenticated?(remember_digest, token)
  end
end
