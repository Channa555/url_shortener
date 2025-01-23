Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api, defaults: { format: :json } do
    resources :urls, only: [ :create ] do
      get ":short_url", to: "urls#show", on: :collection
    end
    post "/api_tokens", to: "api_tokens#create"
  end

  resources :urls, only: [ :new, :create, :show ]
  get "/:short_url", to: "urls#show", as: :shortened
end
