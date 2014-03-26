Blog::Application.routes.draw do


  resources :assets,   :defaults => { :format => 'json' }
  resources :check_routes,   :defaults => { :format => 'json' } ,  :as => :routes, :path => :routes,  :defaults => { :format => 'json' }
  resources :check_points,   :defaults => { :format => 'json' } ,  :as => :points, :path => :points,   :defaults => { :format => 'json' }
  resources :check_results,   :defaults => { :format => 'json' } ,  :as => :results, :path => :results,   :defaults => { :format => 'json' }

  devise_for :admins
  devise_for :users

  root "welcome#index"

  resources :admins, only: :index
end
