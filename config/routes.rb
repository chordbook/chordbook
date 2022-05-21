Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, path: "" do
    get "search(.:format)", to: "search#index", as: :search

    resources :users
    resource :authenticate, controller: "authenticate"

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
      resources :items, controller: :setlist_items
    end
  end

  mount GoodJob::Engine => "admin/jobs"
  get "ping", to: "content#ping"
end
