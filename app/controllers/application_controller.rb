class ApplicationController < ActionController::Base
  before_filter CASClient::Frameworks::Rails::Filter, :except => [ :welcome, :logout ]
  before_filter :set_current_user
  filter_access_to :all, :except => [ :welcome, :logout ]

  protect_from_forgery

  def welcome
    unless session[:cas_user].nil?
      redirect_to new_reservation_url
    end
  end

  def logout
    logger.info "#{session[:cas_user]}@#{request.remote_ip}: Logged out."
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

  def current_user
    Person.find(session[:cas_user])
  end

  protected
  def set_current_user
    Authorization.current_user = current_user
  end
end
