Rails.application.routes.draw do
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :gites, only: [:index, :edit, :update]
  delete "gites/:id/delete/pictures", to: "gites#delete_pictures", as: "delete_pictures"
end
