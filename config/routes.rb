Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchant_search#show'
      get 'items/find_all', to: 'item_search#index'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], to: "merchant_items#index"
      end
      resources :items do
        resources :merchant, only: [:index], to: "merchant_items#show"
      end
    end
  end
end
