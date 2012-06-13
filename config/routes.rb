RequestReservations::Application.routes.draw do
  resources :reservations do
    get 'approve'
    get 'deny'
  end
  
  get '/welcome', :controller => "application", :action => "welcome"
  get '/logout', :controller => "application", :action => "logout"
  
  root :to => 'application#welcome'
end
