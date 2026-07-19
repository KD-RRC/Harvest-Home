Rails.application.routes.draw do
  get "categories/index"
  get "categories/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users

  resources :products, only: [:index, :show]
  resource :cart, only: [:show]
  resources :categories, only: [:index, :show]
  post '/cart/add/:product_id', to: 'carts#add', as: 'add_to_cart'
  delete '/cart/remove/:product_id', to: 'carts#remove', as: 'remove_from_cart'
  patch '/cart/update/:product_id', to: 'carts#update', as: 'update_cart'

  root "products#index"
end