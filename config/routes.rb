Rails.application.routes.draw do
  resources :recipes do
    resources :recipe_ingredients, only: [ :create, :destroy ]
  end
  resource :session
  resources :passwords, param: :token

  resources :ingredients, only: [ :index, :show, :create ] do
    collection do
      get :search
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "recipes#index"
end
