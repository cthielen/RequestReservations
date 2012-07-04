class ApplicationController < ActionController::Base
  include Authentication
  helper :all

  before_filter CASClient::Frameworks::Rails::GatewayFilter
  before_filter :login_required, :except => [ :welcome, :logout ]
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

  def about
    respond_to do |format|
      format.html { render :partial => "about", :layout => false }
    end
  end
end
