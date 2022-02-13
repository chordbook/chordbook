Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "content#index"
  get "404", to: "content#not_found"
  get "offline.json", to: "content#offline"

  namespace :api do
    get "search(.:format)", to: "search#index", as: :search

    get "autocomplete", to: "autocomplete#index"
    resources :artists do
      resources :albums do
        resources :tracks
      end
      resources :tracks
      resources :songsheets, only: [:index]
    end
    resources :albums
    resources :tracks do
      resources :songsheets, only: [:index]
    end
    resources :songsheets
    resources :genres do
      resources :artists, only: [:index]
      resources :tracks, only: [:index]
      resources :albums, only: [:index]
    end
    resources :tracks, only: [:show]
    resources :setlists do
      resources :songsheets, only: [:index]
    end
  end

  mount GoodJob::Engine => "admin/jobs"

  get "*anything", to: "content#index"
end
