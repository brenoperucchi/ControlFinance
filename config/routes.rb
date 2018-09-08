require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  # get 'events/index'
  # mount ActionCable.server => '/cable'

  root to: "public/dashboards#index"

  devise_scope :user do
    get '/admin/',   to: 'admin/sessions#new'
  end

  devise_for :users, controllers:{
    sessions: "public/sessions",
  }

  namespace :site do
    resources :registers, only: [:new, :create]
  end

  namespace :public do
    resources :dashboards, only:[:index] 
    
    resources :assets, only:[:create, :index, :update], path: 'assetable_type/:assetable_type/assetable_id/:assetable_id'
    resources :assets, only:[:destroy]
    resources :purchase_steps, path: 'proposal/:proposal_id' do
      get 'finish', on: :collection
    end
    resources :brokers, only:[:new, :create, :update] do
      get 'revise', on: :member
      get 'contract', on: :member
      get 'assets', on: :member
    end

    resources :stores, only: [:show, :update] do
      resources :builds, only:[:index], shallow:true
    end

    # resources :proposals, only: [:create], path: 'build/:build_id'
    resources :builds, only: [:sales], shallow: true do
      get 'sales', on: :collection
      get 'option/:option', on: :member, action: :option, as: 'option'
      resources :notes, only: :create, path: 'broker/:broker_id'
      resources :proposals, except: [:destroy, :edit] do
        get 'booking', on: :collection
        get 'expired', on: :member
        patch 'comment', on: :member
        get 'invoice', on: :member
      end
    end
  end

  get 'token/:token', to: 'application#redirect_mailer', as: 'redirect_mailer'
  get 'mailer/:method', to: 'admin/mailers#show', as: 'mailer'

  namespace :admin do
    devise_scope :user do
      get '/admin/',   to: 'sessions#new'
      get 'login',   to: 'sessions#new',    as: 'new_session'
      post 'login',  to: 'sessions#create', as: 'session'
      delete 'logout',  to: 'sessions#destroy', as: 'destroy_session'
    end
    resource :store, only:[:edit, :update]
    resources :documents, only:[:create, :index, :update]
    resources :brokers do
      get 'assets', on: :member
    end
    resources :dashboards
    resources :builds do 
      get 'assets', on: :member
      get 'scope/:scope', to: 'builds#scope', on: :member, as: 'scope'
      get 'notify_proposal/:method', to: 'builds#notify_proposal', on: :member, as: 'notify_proposal'

      resources :units, except: [:index] do
        resources :proposals, shallow: true do 
          patch 'comment', on: :member
          get 'invoice/:invoice', on: :member, action: 'invoice', as:'invoice'
          get 'document', on: :member
          get 'act/:act/document_id/:document_id', action: 'action', on: :member, as:'action'
          resources :notes, shallow: true, only: :create
        end
      end
    end
    resources :mailers, only: [:create, :new], path: '/:mailable_type/:mailable_id/:method' do
      get 'notify', on: :collection
    end
  end
end