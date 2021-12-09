Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "content#index"
  get "offline.json", to: "content#offline"

  namespace :api do
    resources :songsheets
  end

  get "*anything", to: "content#index"
end
