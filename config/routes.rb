Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], to: "merchant_items#index"
      end
      resources :items do
        resources :merchant, only: [:index], to: "merchant_items#show"
      end
    end
  end
end
