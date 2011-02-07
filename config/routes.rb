Duckling::Application.routes.draw do
  
  resources :people, controller: 'users'
  
  match '/login' => 'sessions#new', :via => :get, :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
  
  resource :account, controller: 'users' do
    member do
       get :activate
       get :forgot_password
      post :reset_password
    end
  end
  
  resources :activations do
    resources :updates    
    resources :people, controller: 'users'
    resources :groups
  end


  resources :organizations do
    resources :people, controller: 'users', only: [:index]
    resources :sections
    resources :activations, only: [:index]
  end
  
  root to: 'users#new'
  
end
