Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get  '/verify/:user_id', to: 'sessions#verify', as: :verify_with_otp
  post '/check_otp/:user_id', to: 'sessions#check_otp', as: :check_otp

  resources :users, only: [:new, :create]
  resources :subscribers, only: [:create] do
    get :verification
  end
  resources :line_items, only: [:create]

  get '/admin', to: 'admin#index', as: :admin_root

  namespace :admin do
    resources :products
    resource :brand, only: [:new, :create]
    resources :dashboard, only: [:index]
    resources :orders, only: [:index]
    resources :settings, only: [:index]
  end

  get '/:handle', to: 'storefront#show', as: :storefront
end
