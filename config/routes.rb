# == Route Map
#
#                    Prefix Verb   URI Pattern                                                                              Controller#Action
#      destroy_empty_albums POST   /api/albums/destroy_empty(.:format)                                                      albums#destroy_empty
#              album_tracks GET    /api/albums/:album_id/tracks(.:format)                                                   tracks#index
#                    albums GET    /api/albums(.:format)                                                                    albums#index
#                           POST   /api/albums(.:format)                                                                    albums#create
#                     album GET    /api/albums/:id(.:format)                                                                albums#show
#                           PATCH  /api/albums/:id(.:format)                                                                albums#update
#                           PUT    /api/albums/:id(.:format)                                                                albums#update
#                           DELETE /api/albums/:id(.:format)                                                                albums#destroy
#     destroy_empty_artists POST   /api/artists/destroy_empty(.:format)                                                     artists#destroy_empty
#             artist_albums GET    /api/artists/:artist_id/albums(.:format)                                                 albums#index
#             artist_tracks GET    /api/artists/:artist_id/tracks(.:format)                                                 tracks#index
#                   artists GET    /api/artists(.:format)                                                                   artists#index
#                           POST   /api/artists(.:format)                                                                   artists#create
#                    artist GET    /api/artists/:id(.:format)                                                               artists#show
#                           PATCH  /api/artists/:id(.:format)                                                               artists#update
#                           PUT    /api/artists/:id(.:format)                                                               artists#update
#                           DELETE /api/artists/:id(.:format)                                                               artists#destroy
#               auth_tokens GET    /api/auth_tokens(.:format)                                                               auth_tokens#index
#                           POST   /api/auth_tokens(.:format)                                                               auth_tokens#create
#                auth_token GET    /api/auth_tokens/:id(.:format)                                                           auth_tokens#show
#                           DELETE /api/auth_tokens/:id(.:format)                                                           auth_tokens#destroy
#                    codecs GET    /api/codecs(.:format)                                                                    codecs#index
#                           POST   /api/codecs(.:format)                                                                    codecs#create
#                     codec GET    /api/codecs/:id(.:format)                                                                codecs#show
#                           PATCH  /api/codecs/:id(.:format)                                                                codecs#update
#                           PUT    /api/codecs/:id(.:format)                                                                codecs#update
#                           DELETE /api/codecs/:id(.:format)                                                                codecs#destroy
#         codec_conversions GET    /api/codec_conversions(.:format)                                                         codec_conversions#index
#                           POST   /api/codec_conversions(.:format)                                                         codec_conversions#create
#          codec_conversion GET    /api/codec_conversions/:id(.:format)                                                     codec_conversions#show
#                           PATCH  /api/codec_conversions/:id(.:format)                                                     codec_conversions#update
#                           PUT    /api/codec_conversions/:id(.:format)                                                     codec_conversions#update
#                           DELETE /api/codec_conversions/:id(.:format)                                                     codec_conversions#destroy
#           cover_filenames GET    /api/cover_filenames(.:format)                                                           cover_filenames#index
#                           POST   /api/cover_filenames(.:format)                                                           cover_filenames#create
#            cover_filename GET    /api/cover_filenames/:id(.:format)                                                       cover_filenames#show
#                           DELETE /api/cover_filenames/:id(.:format)                                                       cover_filenames#destroy
#      destroy_empty_genres POST   /api/genres/destroy_empty(.:format)                                                      genres#destroy_empty
#                    genres GET    /api/genres(.:format)                                                                    genres#index
#                           POST   /api/genres(.:format)                                                                    genres#create
#                     genre GET    /api/genres/:id(.:format)                                                                genres#show
#                           PATCH  /api/genres/:id(.:format)                                                                genres#update
#                           PUT    /api/genres/:id(.:format)                                                                genres#update
#                           DELETE /api/genres/:id(.:format)                                                                genres#destroy
#               image_types GET    /api/image_types(.:format)                                                               image_types#index
#                           POST   /api/image_types(.:format)                                                               image_types#create
#                image_type GET    /api/image_types/:id(.:format)                                                           image_types#show
#                           PATCH  /api/image_types/:id(.:format)                                                           image_types#update
#                           PUT    /api/image_types/:id(.:format)                                                           image_types#update
#                           DELETE /api/image_types/:id(.:format)                                                           image_types#destroy
#      destroy_empty_labels POST   /api/labels/destroy_empty(.:format)                                                      labels#destroy_empty
#                    labels GET    /api/labels(.:format)                                                                    labels#index
#                           POST   /api/labels(.:format)                                                                    labels#create
#                     label GET    /api/labels/:id(.:format)                                                                labels#show
#                           PATCH  /api/labels/:id(.:format)                                                                labels#update
#                           PUT    /api/labels/:id(.:format)                                                                labels#update
#                           DELETE /api/labels/:id(.:format)                                                                labels#destroy
#                 locations GET    /api/locations(.:format)                                                                 locations#index
#                           POST   /api/locations(.:format)                                                                 locations#create
#                  location GET    /api/locations/:id(.:format)                                                             locations#show
#                           DELETE /api/locations/:id(.:format)                                                             locations#destroy
#      destroy_empty_tracks POST   /api/tracks/destroy_empty(.:format)                                                      tracks#destroy_empty
#               audio_track GET    /api/tracks/:id/audio(.:format)                                                          tracks#audio
#               merge_track POST   /api/tracks/:id/merge(.:format)                                                          tracks#merge
#                    tracks GET    /api/tracks(.:format)                                                                    tracks#index
#                           POST   /api/tracks(.:format)                                                                    tracks#create
#                     track GET    /api/tracks/:id(.:format)                                                                tracks#show
#                           PATCH  /api/tracks/:id(.:format)                                                                tracks#update
#                           PUT    /api/tracks/:id(.:format)                                                                tracks#update
#                           DELETE /api/tracks/:id(.:format)                                                                tracks#destroy
#                     users GET    /api/users(.:format)                                                                     users#index
#                           POST   /api/users(.:format)                                                                     users#create
#                      user GET    /api/users/:id(.:format)                                                                 users#show
#                           PATCH  /api/users/:id(.:format)                                                                 users#update
#                           PUT    /api/users/:id(.:format)                                                                 users#update
#                           DELETE /api/users/:id(.:format)                                                                 users#destroy
#                    rescan GET    /api/rescan(.:format)                                                                    rescan#show
#                           POST   /api/rescan(.:format)                                                                    rescan#start
#        rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
# rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#        rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
# update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#      rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

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
    end
    resources :image_types
    resources :labels do
      collection do
        post 'destroy_empty'
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
