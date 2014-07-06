Helpdesk::Engine.routes.draw do

  resources :tickets do
  	resources :discussions
  end
  resources :teams
  root to: "tickets#index"
end
