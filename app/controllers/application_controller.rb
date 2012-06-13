class ApplicationController < ActionController::Base
  before_filter CASClient::Frameworks::Rails::Filter, :except => [ :welcome, :logout ]
  
  protect_from_forgery
  
  def welcome
  end
  
  def logout
    logger.info "#{session[:cas_user]}@#{request.remote_ip}: Logged out."
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
