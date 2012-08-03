class Communication < ActiveRecord::Base
  using_access_control

  validates_inclusion_of :method, :in => %w( 'E-Mail' 'SysAid' ), :message => "method %s is not valid"
  validates :method, :name, :value, :presence => true

  attr_accessible :method, :name, :value
end
