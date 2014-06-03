Blog::Application.routes.draw do
  resources :route_builders
  resources :notification
  resources :assets
  resources :check_routes, :path => :routes
  resources :check_points,     :path => :points do
    resources :history, controller: 'check_results', only: [:index]
  end
  resources :check_results, :path => :results
  resources :user_preferences
  resources :factories, only: [:index]

  devise_for :users, controllers: { sessions: "users/sessions" }

  root to: 'static_pages#home'

  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

  resources :admins, only: :index
  resources :users
  resources :file
end
