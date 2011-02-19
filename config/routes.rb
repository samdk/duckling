Duckling::Application.routes.draw do
    
  get "session/new"

  get "session/destroy"

  get "session/create"

  match '/login'  => 'sessions#new', :via => :get, :as => :login
  resource :session, only: [:new, :destroy, :create]
  
  resources :people, controller: 'users'
  
  resource :account, controller: 'users' do
    member do
       get :activate
       get :forgot_password
      post :reset_password
    end
  end
  
  resources :activations do
    resources :updates    
    resources :people, controller: 'users', only: [:index]
    resources :groups
  end

  resources :organizations do
    resources :people, controller: 'users', only: [:index]
    resources :sections
    resources :activations, only: [:index]
  end
  
  root to: 'users#new'
  
end
