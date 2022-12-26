Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, path: "" do
    get "search(.:format)", to: "search#index", as: :search

    resource :home, controller: "home"
    resource :discover, controller: "discover"
    resource :library, controller: "library"

    resources :users
    resource :authenticate, controller: "authenticate"
    resource :password, controller: "password"

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
      resources :items, controller: :setlist_items
    end
  end

  resources :sitemaps

  mount GoodJob::Engine => "admin/jobs"
  mount Motor::Admin => "/admin"
  get "ping", to: "content#ping"

  get "*path", as: :client,
    to: redirect(host: ChordBook::CLIENT_URI.host, port: ChordBook::CLIENT_URI.port),
    defaults: {host: ChordBook::CLIENT_URI.host, port: ChordBook::CLIENT_URI.port}
end
