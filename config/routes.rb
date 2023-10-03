Rails.application.routes.draw do
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :gites, only: [:index, :edit, :update, :new, :create]
  delete "gites/:id/delete/pictures", to: "gites#delete_pictures", as: "delete_pictures"
  # patch "gites/:id/change/index", to:'gites#change_index', as:"change_index"

  resources :saisons, only: %i[create delete update]

  get "/domi", to: "admins#admin", as: "admin"
end
