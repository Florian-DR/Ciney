Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "/domi", to: "pages#admin", as: "admin"

  get "/about", to: "pages#about"

  get "/contact", to: "pages#contact"
  post "/contact", to: "pages#contact_sender"

  get "/reservation", to: "reservations#reservation"
  post "/reservation/gites", to: "reservations#gites_reservation_sender"
  post "/reservation/mariages", to: "reservations#mariages_reservation_sender"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :home_pages, only: [:edit, :update]
  
  # Params is to give the name in the url instead of the id
  resources :gites, only: [:show, :edit, :update], param: :name 
  # get "gites/:name", to: "gites#first_gite", as: "first_gite"
  # get "gites/:name", to: "gites#second_gite", as: "second_gite"
  # get "gites/:name", to: "gites#third_gite", as: "third_gite"
  # patch "gites/:id/change/index", to:'gites#change_index', as:"change_index"

  resources :saisons, only: %i[create destroy] do
    resources :days_of_weeks, only: %i[create update]
  end

  resources :holidays, only: %i[create destroy] do 
    resources :gite_holidays, only: %i[create update]
  end

  resources :charges, only: %i[create destroy update]
  delete "gites/:id/delete/pictures", to: "gites#delete_pictures", as: "delete_pictures"
end
