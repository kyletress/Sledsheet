Sledsheet::Application.routes.draw do
  resources :users
  root 'static_pages#home'
  match '/about', to: 'static_pages#about', via: 'get'
  match '/signup', to: 'users#new', via: 'get'
end
