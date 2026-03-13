Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "application#index"

  resources :about, only: [:index, :update]
  resources :projects
  resources :work_experiences
  resources :educations
end
