class Subnet < ActiveRecord::Base
  using_access_control
  attr_accessible :name
end
