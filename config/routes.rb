Pairworking::Application.routes.draw do

  resources :pairs do
    member do
      get :kick_off
      post :check_in
      get :desk_check
      post :check_out
    end
  end

  resources :grads do
    member do
      post :get_away
      post :come_back
    end
  end

  root "pages#home"

  get "/home", to: "pages#home", as: "home"
  get "/find_pair", to: "pages#find_pair", as: "find_pair"

end
