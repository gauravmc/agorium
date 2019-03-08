class Address < ApplicationRecord
  include AddressValidation

  validates :address_line_1, presence: true, length: { maximum: 255 }
  validates :address_line_2, length: { maximum: 255 }
  validates :landmark, length: { maximum: 255 }
  validates :pincode, format: { with: /\A\d{6}\z/, message: "should be a 6-digit number" }

  belongs_to :customer
end
