class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :phone, format: { with: /\A\d{10}\z/, message: "should be a 10-digit number" }
  validates :phone, uniqueness: true

  def phone_successfully_verified!
    update_attribute(:phone_verified, true)
  end
end
