class Status < ActiveRecord::Base
  using_access_control
  attr_accessible :label
end
