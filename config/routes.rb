Rails.application.routes.draw do
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#home'
  get '/signup', to: 'users#new'
  get '/in-kuerze', to:  'static_pages#in_kuerze' #test 
  get '/ueber-mich', to: 'static_pages#ueber_mich'
  get '/impressum', to: 'static_pages#impressum'
  get '/datenschutz', to: 'static_pages#datenschutz'
  get '/kontakt', to: 'static_pages#kontakt'
  get '/videos', to: 'static_pages#videos'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  

  resources :users

end
