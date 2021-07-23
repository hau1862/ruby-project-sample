Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    get "/home", to: "static_page#home"
    get "/help", to: "static_page#help"
    get "/contact", to: "static_page#contact"
    get "/about", to: "static_page#about"

    resources :users

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :account_activations, only: :edit
  end
end
