Rails.application.routes.draw do

  patch 'users_otp/enable'
  patch 'users_otp/disable'
  patch 'users_otp/enable_reset_password'
  patch 'users_otp/disable_reset_password'

  devise_for :users, :controllers => { 
    :passwords => "passwords", sessions: "sessions" } 
    #cambio de pass en primer login(passwords) y cambio de aut2p (sessions)

  get 'saml_login', to: "application#saml_login"
  post 'saml_callback', to: "application#saml_callback"

  resources :clients
  root "articles#home"

  resources :articles do
    resources :comments
  end
end



