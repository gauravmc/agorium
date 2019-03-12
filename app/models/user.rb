class User < ApplicationRecord
  extend Encryption
  include PhoneValidation

  before_validation :strip_string_attributes

  validates :name, presence: true, length: { maximum: 255 }

  has_one :brand, foreign_key: :owner_id, dependent: :destroy

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

  private

  def strip_string_attributes
    self.name = name.try(:strip)
    self.phone = phone.try(:strip)
  end
end
