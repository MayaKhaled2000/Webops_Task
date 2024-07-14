Rails.application.routes.draw do
 
  
  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'

  resources :posts do
    resources :comments
    resources :tags do
      patch 'update_post_tags', on: :collection
    end
  end
  
end