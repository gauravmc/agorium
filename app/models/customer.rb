class Customer < ApplicationRecord
  include PhoneValidation

  before_validation :strip_string_attributes

  validates :name, presence: true, length: { maximum: 255 }

  has_one :address, -> { order('created_at DESC') }, inverse_of: :customer

  accepts_nested_attributes_for :address

  private

  def strip_string_attributes
    self.name = name.try(:strip)
    self.phone = phone.try(:strip)
  end
end
