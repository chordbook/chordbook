Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "songsheets#index"
  resources :songsheets
  get "offline.json", to: "content#offline"
  get "tuner", to: "content#tuner"
end
