Rails.application.routes.draw do
  resources :urls, only: [ :new, :create, :show ]
  get "/:short_url", to: "urls#show", as: :shortened
end
