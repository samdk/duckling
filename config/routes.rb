Duckling::Application.routes.draw do
    
  get 'session/new'
  delete 'session/destroy'
  post 'session/create'

  match '/login'  => 'session#new', :via => :get, :as => :login
  match '/logout' => 'session#destroy', :via => :delete, :as => :logout
  match '/overview' => 'activations#overview', :via => :get, :as => :overview
  
  resource :session, only: [:new, :destroy, :create]

  resources :people, controller: 'users', as: 'users' do
    get 'avatar_:style.png', to: 'users#avatar', on: :member, as: :user_avatar
  end

  resources :attachments, only: [:show]
  
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
    resources :sections do
      put :join, to: :join
      put :join, to: :leave
    end

    resources :updates do
      resources :comments
    end
    
    get 'overview', on: :collection

    member do
        post :rejoin
        post 'organization_rejoin/:organization_id', to: :organization_rejoin
      delete :leave
      delete 'organization_leave/:organization_id', to: :organization_leave
    end
  end

  resources :organizations do
    post :invite
    post :revoke
    resources :people, controller: 'users', only: [:index]
    resources :activations, only: [:index]

    resources :groups
  end

  root to: 'home#landing'
end
