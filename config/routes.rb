Rails.application.routes.draw do
  resources :listings do
    member do
      post :view
      post :save_event
      post :inquiry
      
      # Insights endpoints
      get "insights", to: "insights#index"
      get "insights/summary", to: "insights#summary"
      get "insights/timeseries", to: "insights#timeseries"
    end
  end
end
