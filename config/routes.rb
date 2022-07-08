Rails.application.routes.draw do

  devise_for :users, :controllers => { :passwords => "passwords" }

  get 'saml_login', to: "application#saml_login"
  post 'saml_callback', to: "application#saml_callback"

  resources :clients
  root "articles#home"

  resources :articles do
    resources :comments
  end
end



