Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users

  resources :products,   only: [:index, :show]
  resources :categories, only: [:index, :show]

  resource  :cart, only: [:show]
  post   '/cart/add/:product_id',    to: 'carts#add',    as: 'add_to_cart'
  delete '/cart/remove/:product_id', to: 'carts#remove', as: 'remove_from_cart'
  patch  '/cart/update/:product_id', to: 'carts#update', as: 'update_cart'

  get  '/checkout',          to: 'checkout#index',    as: 'checkout'
  post '/checkout/confirm',  to: 'checkout#confirm',  as: 'checkout_confirm'
  post '/checkout/complete', to: 'checkout#complete', as: 'checkout_complete'
  get  '/checkout/done',     to: 'checkout#done',     as: 'checkout_done'

  root 'products#index'
end