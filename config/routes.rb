Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  scope "(:locale)", locale: /en|es|fr|pt/ do
    resource :session
    resources :passwords, param: :token
    resource :registration, only: [ :new, :create ]

    get "/curriculum", to: "curriculum#index", as: :curriculum
    resources :lessons, only: [ :show ] do
      post :complete, on: :member
    end

    resources :hackathons, only: [ :index ]

    # Admin namespace
    namespace :admin do
      root to: "dashboard#index"
      resources :users, only: [ :index, :show, :edit, :update ]
    end

    root "pages#home"
    get "/next", to: "pages#next_page"
    get "/faq", to: "pages#faq"
    get "/ai-risks-benefits", to: "pages#ai_risks_benefits"
  end
end
