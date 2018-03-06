module Bank
  class UserAPI < Grape::API
    prefix 'api'
    version 'v1', using: :path
    format :json
    namespace :user do
      desc 'list all users'

      get '/users' do
        @users = User.all
        @users
      end

      desc 'create user'
      params do
        requires :email ,type:String, allow_blank: false
        requires :password
        requires :password_confirmation
      end
      post '/create' do
        declared_params = declared(params, include_missing: false)
        @user = User.new(declared_params)
        if @user.save!
          { message: 'User Successfully Create', user:@user}
        else
          @user.errors
        end
      end
      desc 'authenticate User'
      params do
        requires :email, type: String, desc: 'Email'
        requires :password, type: String, desc: 'Password'
      end
      post '/login' do
        user = User.find_for_database_authentication(email: params[:email])
        if user && user.valid_password?(params[:password])
          {
              auth_token: JWTHelper.encode({user_id: user.id}),
              user: user,
              message:  'Successfully logged in User'
          }
        else
          {errors: ['Invalid Username/Password']}
          status :unauthorized
        end
      end


      desc 'update user details'
      params do
        requires :user, type: Hash do
          requires :email, type: String,desc: 'Email'
          optional :title, type: String,desc: 'Title'
          optional :first_name, type: String,desc: 'First Name'
          optional :last_name, type: String,desc: 'Last Name'
          optional :phone_number, type: Integer,desc: 'Phone Number'
        end
      end

      put '/update' do
        declared_params = declared(params, include_missing: false)
        @user = User.find_by_email(declared_params[:user][:email])
        if @user
          @user.update_attributes(declared_params[:user])
          @user
        else
          { error: "User Doesn't Exist" }
        end
      end

      desc 'forgot password'
      params do
        requires :email,type: String, desc: 'Email'
      end
      post '/forgot' do
        user = User.where(email: params[:email]).first
        if user
          user.generate_password_token!
          # host = request.host.eql?('localhost') ? "#{request.host}:#{request.port}" : request.host
          # UserMailer.password_reset(user,host,"http://192.168.15.126:4000/").deliver_now
          {status: 'ok',message:"Email for reset password Sucessfully send"}
        else
          {error:'Email address not found. Please check and try again.'}
        end
      end

      desc 'reset password'
      params do
        requires :email,type: String, desc: 'Email'
        optional :password
        optional :password_confirmation
      end

      post '/reset' do
        token = params[:token].to_s
        user = User.find_by(reset_password_token:token)
        if user.present? && user.password_token_valid?
          if user.reset_password!(params[:password])
            {status: 'ok',message:"Succesfully updated password"}
          else
            {error: user.errors.full_messages}
          end
        else
          {error:  'Link not valid or expired. Try generating a new link.'}
        end
      end

      desc 'update password'
      params do
        optional :password
        optional :password_confirmation
      end
      put 'update_pasword' do
        current_user = Current.user
        if !params[:password].present?
          render json: {error: 'Password not present'}, status: :unprocessable_entity
          return
        end

        if current_user.reset_password(params[:password],params[:password_confirmation])
          {status: 'ok',message:"Succesfully updated password"}
        else
          {errors: current_user.user.errors.full_messages}
        end
      end
    end
  end
end