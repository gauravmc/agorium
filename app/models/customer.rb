class Customer < ApplicationRecord
  include PhoneValidation

  validates :name, presence: true, length: { maximum: 255 }

  has_one :address, -> { order('created_at DESC') }, inverse_of: :customer

  accepts_nested_attributes_for :address
end
