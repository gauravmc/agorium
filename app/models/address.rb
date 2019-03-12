class Address < ApplicationRecord
  include AddressValidation

  before_validation :strip_string_attributes

  validates :address_line_1, presence: true, length: { maximum: 255 }
  validates :address_line_2, length: { maximum: 255 }
  validates :landmark, length: { maximum: 255 }
  validates :pincode, format: { with: /\A\d{6}\z/, message: "should be a 6-digit number" }

  belongs_to :customer

  private

  def strip_string_attributes
    self.address_line_1 = address_line_1.try(:strip)
    self.address_line_2 = address_line_2.try(:strip)
    self.landmark = landmark.try(:strip)
    self.pincode = pincode.try(:strip)
    self.city = city.try(:strip)
  end
end
