Blog::Application.routes.draw do
  resources :route_builders
  resources :notification
  resources :assets do
    put :attach_point
  end
  resources :check_routes, :path => :routes do
    put :detach_point
    put :attach_point
  end
  resources :check_points,     :path => :points do
    resources :history, controller: 'check_results', only: [:index]
  end
  resources :check_results, :path => :results do
    collection { get 'export' }
  end
  resources :check_sessions, :path => :sessions
  resources :manuals
  resources :user_preferences
  resources :factories, only: [:index]
  resources :repair_reports
  resources :problem_list do
    collection { get 'export' }
  end

  resources :contacts

  devise_for :users, :skip => [:registrations], controllers: {
    sessions: "users/sessions" }

  root to: 'static_pages#home'

  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

  resources :admins, only: :index
  resources :users do
    get :routes
    put :set_routes
  end
  resources :repair_users
  resources :file
end
