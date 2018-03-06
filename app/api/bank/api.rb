require 'warden'
require 'auth_strategies/json_web_token'
require 'grape-swagger'

module Bank
  class API < Grape::API # :nodoc:
    rescue_from :all
    version 'v1', using: :path
    format :json
    prefix :api
    # api authentication
    # helpers do
    #   def current_user
    #     unless user_logged?
    #       error!('Not Authenticated', 401)
    #       return
    #     end
    #     @current_user = User.find(auth_token["user_id"])
    #     Current.user = @current_user
    #   rescue JWT::VerificationError, JWT::DecodeError
    #     error!('Not Authenticated', 401)
    #   end
    #
    #   private
    #   def http_token
    #     @http_token ||= if request.headers['Authorization'].present?
    #                       request.headers['Authorization'].split(' ').last
    #                     elsif request.headers['Api-Key'].present?
    #                       request.headers['Api-Key'].split(' ').last
    #                     end
    #   end
    #
    #   def auth_token
    #     @auth_token ||= JWTHelper.decode(http_token)
    #   end
    #
    #   def user_logged?
    #     http_token && auth_token && auth_token[:user_id].to_i
    #   end
    # end
    #
    #
    # before do
    #   error!('Access Denied', 401) unless current_user
    # end
    #
    #
    #
    # use Warden::Manager do |manager|
    #   # Register our new JWT strategy
    #   manager.strategies.add(:jwt, AuthStrategies::JSONWebToken)
    #
    #   # Set default to JWT, otherwise while calling authorize!
    #   # we need to pass strategy name
    #   manager.default_strategies :jwt
    #
    #   # This is the responder when the authentication fails
    #   manager.failure_app = manager.failure_app = ->(_env) {
    #     [401, { 'content-type' => 'application/json' },
    #      ['{"error": "Invalid auth_strategies token."}']]
    #   }
    #
    # end
    mount Bank::CustomerAPI
    mount Bank::AccountsAPI
  end
end