Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :customers, controllers: { omniauth_callbacks: "customers/omniauth_callbacks" }

  resources :categories,  only: :show
  resources :order_items, except: [:new, :show, :edit]

  resources :customers, only: :edit do
    collection do
      patch :update_address
      patch :update_password
      patch :update_email
    end
  end

  resources :books, only: [:index, :show]  do
    resources :ratings, only: [:new, :create]
  end

  resources :orders, only: [:index, :show] do
    member do
      get    :complete
      patch  :add_discount
    end
    delete :clear_cart,   on: :collection
  end

  namespace :checkouts do
    get   :edit_address
    patch :update_address

    get   :choose_delivery
    patch :set_delivery

    get   :confirm_payment
    patch :update_credit_card

    get   :overview
    get   :confirmation
  end

  root 'home#index'
end
