Pairworking::Application.routes.draw do

  resources :pairs do
    member do
      get :kick_off
      post :check_in
      get :desk_check
      post :check_out
    end
  end
  resources :grads
  root "pages#home"

  get "/home", to: "pages#home", as: "home"
  
end
