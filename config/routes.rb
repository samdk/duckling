Duckling::Application.routes.draw do
    
  get "session/new"
  delete "session/destroy"
  post "session/create"

  match '/login'  => 'session#new', :via => :get, :as => :login
  match '/logout' => 'session#destroy', :via => :delete, :as => :logout
  resource :session, only: [:new, :destroy, :create]
    
  resources :people, controller: 'users' do
    get 'avatar_:style.png', to: 'users#avatar', on: :member, as: :user_avatar
  end
  
  resource :account, controller: 'users' do
    member do
       get :activate
       get :forgot_password
      post :reset_password
    end
  end
  
  resources :activations do
    resources :updates do
      get 'attachments/:attach_id/:filename', to: 'updates#attachment',
                                              on: :member,
                                              as: :activations_updates_attachments
    end
    
    match '/people' => 'users#index_activation', :via => :get, :as => :people
    #resources :people, controller: 'users', only: [:index]
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
