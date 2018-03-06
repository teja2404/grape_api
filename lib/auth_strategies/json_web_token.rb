require 'warden'
require 'jwt_helper'

module AuthStrategies
  class JSONWebToken < Warden::Strategies::Base
    def valid?
      env['HTTP_AUTHORIZATION'].present?
    end

    def authenticate!
      claims = decode_claims

      return fail! unless claims
      return fail! unless claims.has_key?('user_id')

      user = User.find_by_id claims['user_id']

      return fail! unless user

      success! user.id
    end

    protected

    def decode_claims
      strategy, token = env['HTTP_AUTHORIZATION'].split(' ')

      return nil if (strategy || '').downcase != 'bearer'

      JWTHelper.decode(token) rescue nil
    end
  end
end