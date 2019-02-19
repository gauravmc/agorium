class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :phone, numericality: true, uniqueness: true

  # :if condition because otherwise Rails unnecessarily
  # validates length even when phone is something non-numeric,
  # creating two errors messages, which is bad UX. Wish
  # there was a better way to do this.
  validates :phone, length: { is: 10 }, if: Proc.new {|u| u.errors[:phone].none?}

  def phone_successfully_verified!
    update_attribute(:phone_verified, true)
  end
end
