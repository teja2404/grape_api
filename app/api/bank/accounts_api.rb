module Bank
  class AccountsAPI < Grape::API
    route_param :branch_id,type: String do
    namespace :account do
      route_param :id,type: Integer do
        after_validation do
          @account = Account.find(params[:id])
        end

        desc 'credit account'
        params do
          requires :amount,type:Float,allow_blank:false
        end

        put '/deposit' do
          @account.deposit(params)
        end

        desc 'debit account'
        params do
          requires :amount,type:Float,allow_blank:false
        end

        put '/withdrawal' do
          @account.withdraw(params)
        end

        desc 'deactivate account'

        get '/deactivate' do
          @account.deactivate
        end

        desc 'activate account'

        get '/activate' do
          @account.activate
        end

        desc 'transfer ammount'

        params do
          requires :frm_account,type:Integer,allow_blank:false
          requires :to_account,type:Integer,allow_blank:false
          requires :amount,type:Integer,allow_blank:false
        end

        post '/transfer' do
          Account.transfer(params)
        end
      end

      desc 'create account'
      params do
        requires :customer_id,type:Integer,allow_blank: false
        optional :account_type,type:String,allow_blank: false
      end

      post '/create' do
        Account.add(params)
      end

      desc 'particular account details'
      get '/:id' do
        Account.find(params[:id])
      end
    end
    desc 'list all accounts'
    get '/accounts' do
      Account.all
    end

    end
  end
end
