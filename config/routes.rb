Rails.application.routes.draw do
  resources :members
  resources :tenants
  devise_for :users
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

# log out won't work without this
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end

  resources :users, only: [:index, :show]

  resources :tenants, only: [:index, :show, :create, :new, :update, :edit, :destroy]
  get 'my/tenants', to: 'tenants#my', as: 'my_tenants' 


  resources :members
  get 'invite/member', to: 'members#invite', as: 'invite_members'

end
