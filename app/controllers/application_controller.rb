class ApplicationController < ActionController::Base
  before_filter CASClient::Frameworks::Rails::Filter
  
  protect_from_forgery
  
  def logout
    
  end
end
