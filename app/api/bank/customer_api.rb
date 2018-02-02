module Bank
  class CustomerAPI<Grape::API
    namespace :customer do
      route_param :id,type: Integer do
        after_validation do
          @customer = Customer.find(params[:id])
        end

        desc 'update customer details'
        params do
          optional :name,type: String, allow_blank: false
          optional :email,type: String, allow_blank: false
          optional :phone,type: Integer, allow_blank: false
          optional :branch_id,type: Integer, allow_blank: false
        end

        put '/update' do
          @customer.update_customer(params)
        end


        desc 'deactivate customer'
        get '/deactivate' do
          @customer.deactivate
          { message:'Customer deactivated sucessfully' }
        end

        desc 'activate customer'
        get '/activate' do
          @customer.activate
          { message:'Customer reactivated sucessfully' }
        end

        desc 'list all accounts of customer'

        get 'list_accounts' do
          @customer.list_accounts
        end
      end

      desc 'add new customer'
      params do
        requires :name,type: String, allow_blank: false
        requires :email,type: String, allow_blank: false
        requires :phone,type: Integer, allow_blank: false
        requires :branch_id,type: Integer, allow_blank: false
        optional :status,type: Boolean, default: :true
      end

      post '/create' do
        Customer.add(params)
      end

      desc 'get particular customer details'
      get '/:id' do
        Customer.find(params[:id])
      end

    end
    desc 'list all customer'
    get '/customers' do
      Customer.all
    end
  end
end