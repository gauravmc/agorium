class Brand < ApplicationRecord
  include AddressValidation

  after_save :update_handle

  validates :name, presence: true, length: { maximum: 255 }
  validates_uniqueness_of :owner, message: "has already created a brand"

  belongs_to :owner, class_name: 'User'
  has_many :products, foreign_key: :owner_id, dependent: :destroy
  has_many :orders

  private

  def update_handle
    if saved_change_to_name? or saved_change_to_handle?
      update_column(:handle, generate_handle)
    end
  end

  def generate_handle
    handle = name.parameterize
    Brand.exists?(handle: handle) ? "#{handle}-#{id}" : handle
  end
end
