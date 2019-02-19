Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  get  '/signup', to: 'users#new'
  post  '/signup', to: 'users#create'

  resources :users, only: [:new, :create] do
    get :verify, to: 'users#verify'
    put :check_otp, to: 'users#check_otp'
  end
end
