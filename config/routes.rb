Rails.application.routes.draw do
  get 'events/index'

  mount ActionCable.server => '/cable'

  root to: "public/dashboards#index"

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
    resources :purchase_steps, path: 'proposal/:proposal_id'
    resources :brokers, only:[:new, :create, :update] do
      get 'revise', on: :member
      get 'contract', on: :member
      get 'assets', on: :member
    end

    resources :stores, only: [] do
      resources :builds, only:[:index], shallow:true
    end

    resources :builds, only:[:index] do
      resources :units, only:[:index], shallow:true do
        resources :proposals, except: [:destroy] do
          get 'booking', on: :collection
          get 'expired', on: :member
          patch 'comment', on: :member
        end
      end
    end
  end

  resources :mailers, only: [:create, :new], path: 'mailable_type/:mailable_type/mailable_id/:mailable_id/method/:method'
  get 'token/:token', to: 'mailers#redirect', as: 'redirect_mailer'
  get 'mailer/:method', to: 'mailers#show', as: 'mailer'


  namespace :admin do
    devise_scope :user do
      get 'login',   to: 'sessions#new',    as: 'new_session'
      post 'login',  to: 'sessions#create', as: 'session'
      delete 'logout',  to: 'sessions#destroy', as: 'destroy_session'
    end
    resources :documents, only:[:create, :index, :update]
    resources :brokers do
      get 'assets', on: :member
    end
    resources :dashboards
    resources :builds do 
      get 'assets', on: :member
      get 'scope/:scope', to: 'builds#scope', on: :member, as: 'scope'
      get 'deliver_mail/:method', to: 'builds#deliver_mail', on: :member, as: 'deliver_mail'

      resources :units, except: [:index] do
        resources :proposals, shallow: true do 
          patch 'comment', on: :member
          get 'document', on: :member
          get 'act/:act/document_id/:document_id', action: 'action', on: :member, as:'action'
        end
      end
    end
  end
end