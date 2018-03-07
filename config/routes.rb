Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  mount Bank::API => '/'
  mount Bank::UserAPI => '/'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
