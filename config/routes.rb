# == Route Map
#

Rails.application.routes.draw do
  scope 'api' do
    resources :albums do
      collection do
        post 'destroy_empty'
      end
      resources :tracks, only: [:index]
    end
    resources :artists do
      collection do
        post 'destroy_empty'
      end
      member do
        post 'merge'
      end
      resources :albums, only: [:index]
      resources :tracks, only: [:index]
    end
    resources :auth_tokens, only: %i[index show create destroy]
    resources :codecs
    resources :codec_conversions
    resources :cover_filenames, only: %i[index show create destroy]
    resources :genres do
      collection do
        post 'destroy_empty'
      end
      member do
        post 'merge'
      end
    end
    resources :image_types
    resources :labels do
      collection do
        post 'destroy_empty'
      end
      member do
        post 'merge'
      end
    end
    resources :locations, only: %i[index show create destroy]
    resources :tracks do
      collection do
        post 'destroy_empty'
      end
      member do
        get 'audio'
        post 'merge'
      end
    end
    resources :users

    get '/rescan' => 'rescan#show'
    post '/rescan' => 'rescan#start'
  end
end
