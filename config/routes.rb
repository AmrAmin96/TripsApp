Rails.application.routes.draw do
  resources :trips
  post '/trips/:id/submit_location', to: 'trips#submit_location', as: 'submit_location'
  post '/trips/:id/update_status', to: 'trips#update_status', as: 'update_status'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
