Helpdesk::Engine.routes.draw do
  resources :tickets do
  	resources :discussions
  end

  root to: "tickets#index"
end
