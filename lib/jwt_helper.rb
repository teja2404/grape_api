module JWTHelper
  def self.encode(payload)
    JWT.encode(payload, jwt_secret)
  end

  def self.decode(jwt_token)
    JWT.decode(jwt_token, jwt_secret)[0]
  end

  def self.jwt_secret
    Rails.application.secrets.secret_key_base
  end
end