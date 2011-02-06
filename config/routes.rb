Duckling::Application.routes.draw do
  
  resources :people, controller: 'users'
  resources :sessions

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
