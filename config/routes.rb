require 'resque/server'

Duckling::Application.routes.draw do
  
  mount Resque::Server.new, at: '/resque'
    
  get 'session/new'
  delete 'session/destroy'
  post 'session/create'

  match '/login'  => 'session#new', :via => :get, :as => :login
  match '/logout' => 'session#destroy', :via => :delete, :as => :logout
  match '/overview' => 'activations#overview', :via => :get, :as => :overview

  resources :invitations, only: [:create] do
    post 'search', on: :collection
  end

  resource :session, only: [:new, :destroy, :create] do
    get 'without_password/:reset_token', to: :without_password, as: :without_password
  end

  resources :people, controller: 'users', as: 'users' do
    get 'avatar_:style.png', to: 'users#avatar', on: :member, as: :user_avatar
  end

  resources :attachments, only: [:show]

  resource :account, controller: 'users' do    
    member do
       get 'activate'
       get 'forgot_password'
      post 'request_password_reset'
    end
    
    resources :emails, only: [:new, :create, :destroy] do
       get 'verify/:secret_code', to: :verify, as: :verify
    end
  end
  
  resources :activations do
    resources :sections do
      put :join, on: :member
      put :leave, on: :member
    end

    resources :updates do
      resources :comments
    end
    
    get 'overview', on: :collection
    post 'revoke'

    member do
        post 'rejoin'
        post 'organization_rejoin/:organization_id', to: :organization_rejoin
      delete 'leave'
      delete 'organization_leave/:organization_id', to: :organization_leave
    end
  end

  resources :organizations do
    post 'invite'
    post 'revoke'
    resources :people, controller: 'users', only: [:index]
    resources :activations, only: [:index]

    resources :groups
  end

  root to: 'home#landing'
end
