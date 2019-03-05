class Brand < ApplicationRecord
  INDIAN_STATES = [
    'Andaman and Nicobar Islands',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Lakshadweep',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
  ]

  before_validation :lowercase_username
  before_save :capitalize_city

  validates :name, presence: true, length: { maximum: 255 }
  USERNAME_REGEX = /\A[\w.]+\z/i
  validates :username, length: { maximum: 42 },
    format: { with: USERNAME_REGEX, message: "should only have letters, numbers, underscores, and dots" }

  validates :city, format: { with: /\A[a-zA-Z]+\z/i, message: "should only contain letters" }
  validates :state, inclusion: { in: INDIAN_STATES, message: "is not a valid Indian state" }
  validates_uniqueness_of :owner, message: "has already created a brand"

  belongs_to :owner, class_name: 'User'

  private

  def lowercase_username
    self.username = username.downcase if username_changed?
  end

  def capitalize_city
    self.city = city.capitalize if city_changed?
  end
end
