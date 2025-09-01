Rails.application.routes.draw do
  resources :scientists do
    resources :experiments, shallow: true do
      resources :results, shallow: true
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
