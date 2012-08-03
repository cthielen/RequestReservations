RequestReservations::Application.routes.draw do
  resources :reservations do
    get 'approve'
    get 'deny'
  end

  namespace :admin do
    resources :subnets
    resources :communications
  end

  get '/welcome', :controller => "application", :action => "welcome"
  get '/logout', :controller => "application", :action => "logout"
  get '/about', :controller => "application", :action => "about"

  root :to => 'application#welcome'
end
