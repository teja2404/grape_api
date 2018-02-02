module Bank
  class API < Grape::API # :nodoc:
    rescue_from :all
    version 'v1', using: :path
    format :json
    prefix :api
    mount Bank::CustomerAPI
    mount Bank::AccountsAPI
  end
end