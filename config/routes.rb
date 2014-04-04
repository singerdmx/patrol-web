Blog::Application.routes.draw do


  resources :assets
  resources :check_routes, :path => :routes
  resources :check_points,     :path => :points
  resources :check_results, :path => :results

  devise_for :admins
  devise_for :users

  root "welcome#index"

  resources :admins, only: :index
end
