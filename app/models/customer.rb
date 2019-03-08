class Customer < ApplicationRecord
  include PhoneValidation

  validates :name, presence: true, length: { maximum: 255 }

  has_one :address, -> { order('created_at DESC') }
end
