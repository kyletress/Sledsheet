Rails.application.routes.draw do

  root 'static_pages#home'
  get 'about', to: 'static_pages#about'
  get 'signup(/:invitation_token)', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :users # , only: [:show]
  resources :tracks, only: [:index, :show]
  resources :circuits, only: [:index, :show]
  resources :athletes do
    resource :profile
  end
  resources :seasons, only: [:index, :show]
  resources :timesheets do
    post 'import', on: :member
    resources :entries, shallow: true do
      collection { post :sort }
      resources :runs, shallow: true, except: :index
    end
    resources :points, only: [:index, :create]
  end
  resources :invitations
  resources :points

  post 'waitlist', to: 'invitations#waitlist'

  namespace :admin do
    resources :tracks
    resources :users
    resources :circuits
    resources :points
    resources :runs, only: :index
    resources :invitations, only: [:index, :destroy]
  end

  get '/become/:id', to: 'admin#become'

  # match '/about', to: 'static_pages#about', via: 'get'
  # match '/signup', to: 'users#new', via: 'get'
  # match '/signin', to: 'sessions#new', via: 'get'
  # match '/signout', to: 'sessions#destroy', via: 'delete'
  # match 'timesheets/:timesheet_id/startlist', to: 'entries#index', via: 'get'
end
