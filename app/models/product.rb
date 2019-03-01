class Product < ApplicationRecord
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

  belongs_to :owner, class_name: 'User'

  before_validation :set_handle
  before_create :set_published_at

  private

  def set_handle
    if name_changed? or handle_changed?
      self.handle = name.parameterize
    end
  end

  def set_published_at
    self.published_at = DateTime.now.utc
  end
end
