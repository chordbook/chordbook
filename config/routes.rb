Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "content#index"
  get "404", to: "content#not_found"
  get "offline.json", to: "content#offline"

  namespace :api do
    get "autocomplete", to: "autocomplete#index"
    resources :artists do
      resources :albums do
        resources :tracks
      end
      resources :tracks
    end
    resources :albums
    resources :songsheets
  end

  get "*anything", to: "content#index"
end
