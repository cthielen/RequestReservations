RequestReservations::Application.routes.draw do
  resources :reservations

  root :to => 'reservations#new'
  
  get '/logout', :controller => "application", :action => "logout"
end
