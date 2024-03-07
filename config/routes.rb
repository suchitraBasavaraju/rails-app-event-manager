Rails.application.routes.draw do
  devise_for :users
  root 'events#index'
  post 'events/create_event_a', to: 'events#create_event_a', as: 'create_event_a'
  post 'events/create_event_b', to: 'events#create_event_b', as: 'create_event_b'
  post 'events/send_email_for_events', to: 'events#send_email_for_events', as: 'send_email_for_events'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
