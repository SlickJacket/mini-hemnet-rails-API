Rails.application.routes.draw do
  resources :listings do
    member do
      post :view
      post :save_event
      post :inquiry
      get :insights
    end
  end
end

