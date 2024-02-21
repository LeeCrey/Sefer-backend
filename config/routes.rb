# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, constraints: { id: /\d+/ }, defaults: { format: :json, locale: :en } do
    namespace :v1, shallow: true do
      resources :short_videos, except: %i[show] do
        member do
          post 'vote' => 'short_videos#vote'
        end
      end

      resources :chats

      # Community
      post 'community_members/:id/approve' => 'community_members#approve'
      resources :communities do
        member do
          get 'members' => 'community_members#index'
          delete 'leave' => 'community_members#leave'
          post 'join' => 'community_members#join'
          get 'posts' => 'communities#posts'
          post 'posts' => 'communities#add_post'
        end
      end
      get 'communities/discover' => 'communities#discover'

      # User
      resources :users, only: %i[index show] do
        member do
          get 'videos' => 'users#videos'
          get 'posts' => 'users#posts'
          post 'block' => 'users#block'
          delete 'unblock' => 'users#unblock'

          post 'follow' => 'follows#follow'
          delete 'unfollow' => 'follows#unfollow'
          get 'followers' => 'follows#followers'
          get 'followings' => 'follows#followings'
        end
      end
      get 'users/blocked' => 'users#blocked_users'
      get 'users/search' => 'users#search'

      resources :posts, shallow: true do
        member do
          get 'users' => 'posts#users'
          post 'vote' => 'posts#vote'
        end
      end
      resources :comments do
        resources :replies, only: %i[index create]
        member do
          post 'vote' => 'comments#vote'
        end
      end

      get 'posts/liked' => 'posts#liked'
      get 'posts/search' => 'posts#search'
      # route for polymorphic table(posts, short_videos ...)
      # contraints
      #   1. It should be lower case only
      #   2. It should end with s
      constraints(commentable_id: /\d+/, commentable_type: /[a-z]+s/) do
        get '/:commentable_type/:commentable_id/comments' => 'comments#index'
        post '/:commentable_type/:commentable_id/comments' => 'comments#create'
      end

      resources :products
    end
  end

  devise_for :users,
             defaults: { format: :json },
             path_names: {
               sign_in: 'login',
               sign_up: 'register',
               sign_out: 'logout',
             }, controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations',
               passwords: 'users/passwords',
               confirmations: 'users/confirmations',
               unlocks: 'users/unlocks',
             }

  devise_for :shops, defaults: { format: :json },
                     path_names: {
                       sign_in: 'login',
                       sign_up: 'register',
                       sign_out: 'logout',
                     }

  post 'fcm_token' => 'helpers#fcm_update'
  get '.well-known/assetlinks' => 'helpers#asset_links'

  match '*unmatched', to: 'application#page_not_found', via: :all
end
