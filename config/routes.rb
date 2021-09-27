Rails.application.routes.draw do
  get '/in-kuerze', to:  'static_pages#in_kuerze'
  get '/ueber-mich', to: 'static_pages#ueber_mich'
  get '/impressum', to: 'static_pages#impressum'
  get '/datenschutz', to: 'static_pages#datenschutz'
  get '/kontakt', to: 'static_pages#kontakt'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#home'

end
