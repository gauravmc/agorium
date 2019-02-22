class SessionForm
  include ActiveModel::Validations

  attr_accessor :phone, :user

  def initialize(phone: nil)
    self.phone = phone
  end

  validates :phone, format: { with: /\A\d{10}\z/, message: "should be a 10-digit number" }
  validate :user_exists_with_that_phone_number

  private

  def user_exists_with_that_phone_number
    return if errors.any?

    unless self.user = User.find_by(phone: phone)
      errors.add(:base, 'We couldn’t find an account with that number')
    end
  end
end
