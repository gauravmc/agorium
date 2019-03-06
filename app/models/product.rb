class Product < ApplicationRecord
  PHOTOS_CONTENT_TYPE = 'image/jpeg'

  before_validation :set_handle
  before_create :set_published_at

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true
  validates :price, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: BigDecimal(10**7)
  }
  validates :cost, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: BigDecimal(10**7)
  }
  validates :inventory, numericality: { greater_than_or_equal_to: 0 }
  validates :handle, uniqueness: { scope: :owner_id }
  validate :presence_and_type_of_attached_photos

  belongs_to :owner, class_name: 'Brand'
  has_many_attached :photos

  private

  def presence_and_type_of_attached_photos
    if photos.attached?
      if photos.any? { |photo| photo.content_type != PHOTOS_CONTENT_TYPE }
        errors.add(:photos, "must be of type #{PHOTOS_CONTENT_TYPE} only")
      end
    else
      errors.add(:photos, "must be present. Add at least one photo")
    end
  end

  def set_handle
    if name_changed? or handle_changed?
      self.handle = name.parameterize
    end
  end

  def set_published_at
    self.published_at = DateTime.now.utc
  end
end
