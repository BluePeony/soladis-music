Rails.application.routes.draw do
  get 'tracks/new'
  get 'tracks/create'
  get 'tracks/edit'
  get 'tracks/update'
  get 'tracks/show'
  get 'tracks/index'
  get 'tracks/destroy'
  get 'password_resets/new'
  get 'password_resets/edit'
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#home'
  get '/signup', to: 'users#new'
  get '/in-kuerze', to:  'static_pages#in_kuerze' #test 
  get '/ueber-mich', to: 'static_pages#ueber_mich'
  get '/impressum', to: 'static_pages#impressum'
  get '/datenschutz', to: 'static_pages#datenschutz'
  get '/kontakt', to: 'static_pages#kontakt'
  get '/videos', to: 'static_pages#videos'
  get '/all_tracks', to: 'tracks#all_tracks'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :tracks

end
