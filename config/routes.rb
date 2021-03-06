Rails.application.routes.draw do
 
  resources :visitor_pages
  resources :contacts, only: [:index]  #set to admin only
  #welcome page 
  root "static#home"
  get "/welcome-to-crm", to: "users#welcome"
  post "/welcome-to-crm", to: "users#welcome_create_lead"

   #see visitor with most visits
   get "/apps/:app_id/visitors/most-recent", to: "visitors#most_recent", as: "most_recent"


  #sign-up with google or signup via crm
  get "/signup", to: "users#new"
  
  #track users across website
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete '/logout', to: "sessions#destroy"

  post "/submission", to: "contacts#contact_created_from_page"

 
  #identify if the user has visitor instance.
  post "/apps/:app_id/contacts/:id/identify", to: "contacts#identify", as: "identify"

  #oauth
  get '/auth/:provider/callback', to: 'sessions#omniauth'

   
    
  resources :users, only: [:index, :create] #set some of routes only for admin
  resources :visitors, only: [:index, :new, :create]
 

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  #user
  resources :apps, only: [:show, :create, :edit, :update, :destroy] do 
    resources :users, only: [:index, :new, :show, :create, :edit, :update, :destroy]
    resources :visitors, only: [:index, :new,  :show, :create, :edit, :update, :destroy]
    resources :contacts, only: [:index, :new, :show, :create, :edit, :update, :destroy]
    resources :pages
  end




 
end
