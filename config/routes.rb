RequestReservations::Application.routes.draw do
  resources :reservations do
    get 'approve'
    get 'deny'
  end

  root :to => 'reservations#new'
  
  get '/logout', :controller => "application", :action => "logout"
end
