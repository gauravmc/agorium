class Cart < ApplicationRecord
  belongs_to :brand
  has_many :line_items, dependent: :destroy

  def add_product(product)
    if line_item = line_items.find_by(product: product)
      line_item.increment(:quantity)
    else
      line_items.build(product: product)
    end
  end

  def quantity
    line_items.sum(&:quantity)
  end
end
