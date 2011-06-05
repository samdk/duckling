Duckling::Application.routes.draw do
    
  get "session/new"
  delete "session/destroy"
  post "session/create"

  match '/login'  => 'session#new', :via => :get, :as => :login
  match '/logout' => 'session#destroy', :via => :delete, :as => :logout
  resource :session, only: [:new, :destroy, :create]

  match '/attachments/:id', to: 'updates#attachment'
    
  resources :people, controller: 'users', as: 'users' do
    get 'avatar_:style.png', to: 'users#avatar', on: :member, as: :user_avatar
  end
  
  resource :account, controller: 'users' do
    
    member do
       get :activate
       
       get :forgot_password
      post :request_password_reset
       get 'new_password/:id_:token', to: :new_password, as: :new_password
      post :reset_password
    end
  end
  
  resources :activations do
    resources :updates do
      resources :comments
    end

    member do
        post :rejoin
        post 'organization_rejoin/:organization_id', to: :organization_rejoin
      delete :leave
      delete 'organization_leave/:organization_id', to: :organization_leave
    end
    
    resources :people, controller: 'users', only: [:index]
    resources :groups    
  end

  resources :organizations do
    resources :people, controller: 'users', only: [:index]
    resources :sections
    resources :activations, only: [:index]
  end
  
  # TODO: change this to something more sane
  root to: 'activations#index'
  #root to: 'users#new'
  
end
