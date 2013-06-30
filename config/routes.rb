Helpdesk::Engine.routes.draw do
  resources :tickets do
  	resources :posts
  end

  root to: "tickets#index"
end
