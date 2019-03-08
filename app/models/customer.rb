class Customer < ApplicationRecord
  include PhoneValidation

  validates :name, presence: true, length: { maximum: 255 }
end
