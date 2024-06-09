Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "/domi", to: "pages#admin", as: "admin"

  get "/contact", to: "contacts#contact"
  post "/contact/gites", to: "contacts#gites_reservation_sender"
  post "/contact/mariages", to: "contacts#mariages_reservation_sender"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :home_pages, only: [:edit, :update]

  resources :gites, only: [:index, :edit, :update]
  # patch "gites/:id/change/index", to:'gites#change_index', as:"change_index"

  resources :saisons, only: %i[create destroy] do
    resources :days_of_weeks, only: %i[create update]
  end

  resources :holidays, only: %i[create destroy] do 
    resources :gite_holidays, only: %i[create update]
  end

  resources :charges, only: %i[create destroy]
  delete "gites/:id/delete/pictures", to: "gites#delete_pictures", as: "delete_pictures"
end
