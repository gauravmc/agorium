class Brand < ApplicationRecord
  LOGO_CONTENT_TYPES = ['image/png', 'image/jpeg']

  include AddressValidation

  after_save :update_handle
  before_validation :strip_string_attributes

  validates :name, presence: true, length: { maximum: 255 }
  validates_uniqueness_of :owner, message: "has already created a brand"
  validate :type_of_attached_logo
  validate :size_of_attached_logo

  belongs_to :owner, class_name: 'User'
  has_many :products, foreign_key: :owner_id, dependent: :destroy
  has_many :orders
  has_one_attached :logo

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

  def type_of_attached_logo
    if logo.attached? && !logo.content_type.in?(LOGO_CONTENT_TYPES)
      errors.add(:logo, "must be either a png or jpeg type image")
    end
  end

  def size_of_attached_logo
    if logo.attached? && logo.byte_size > 5.megabytes
      errors.add(:logo, "size should not be bigger than 5 MB")
    end
  end

  def strip_string_attributes
    self.name = name.try(:strip)
    self.tagline = tagline.try(:strip)
    self.city = city.try(:strip)
  end
end
