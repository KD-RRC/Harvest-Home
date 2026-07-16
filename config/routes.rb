Rails.application.routes.draw do
  resource :cart, only: [:show]
  post '/cart/add/:product_id', to: 'cart#add', as: 'add_to_cart'
  delete '/cart/remove/:product_id', to: 'cart#remove', as: 'remove_from_cart'
  patch '/cart/update/:product_id', to: 'cart#update', as: 'update_cart'
  get "cart/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :products, only: [:index, :show]
  root "products#index"
end