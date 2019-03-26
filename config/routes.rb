Rails.application.routes.draw do
  resources :codecs
  resources :auth_tokens, only: [:index, :show, :create, :destroy]
  resources :users
end
