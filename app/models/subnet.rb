class Subnet < ActiveRecord::Base
  using_access_control
  validates :name, :presence => true

  attr_accessible :name
end
