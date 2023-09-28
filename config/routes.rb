Rails.application.routes.draw do
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :gites, only: [:index, :edit, :update]
  post "gites/:id/add/pictures", to: "gites#add_pictures", as: "add_pictures"
end
