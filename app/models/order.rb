class Order < ApplicationRecord
  belongs_to :brand
  belongs_to :customer

  enum status: {
    pending: 'pending',
    confirmed: 'confirmed',
    shipped: 'shipped',
    cancelled: 'cancelled'
  }
end
