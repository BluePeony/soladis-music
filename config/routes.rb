Rails.application.routes.draw do
  root 'tracks#home'

  get 'videos/new'
  get 'videos/edit'
  get 'videos/index'
  get 'videos/show'
  get 'tracks/new'
  get 'tracks/create'
  get 'tracks/edit'
  get 'tracks/update'
  get 'tracks/show'
  get 'tracks/index'
  get 'tracks/destroy'
  get 'tracks/search', to: 'tracks#search'
  get 'password_resets/new'
  get 'password_resets/edit'
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    
  get '/signup', to: 'users#new'
  get '/in-kuerze', to:  'static_pages#in_kuerze' #test 
  get '/ueber-mich', to: 'static_pages#ueber_mich'
  get '/impressum', to: 'static_pages#impressum'
  get '/datenschutz', to: 'static_pages#datenschutz'
  get '/kontakt', to: 'static_pages#kontakt'
  get '/all_tracks', to: 'tracks#all_tracks'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  

  resources :users
  resources :videos
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  get '/music', to: 'tracks#music'

  resources :tracks



end
