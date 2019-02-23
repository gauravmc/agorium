module Encryption
  # This is taken from Rails' implementation of has_secure_password
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(digest, token)
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
end
