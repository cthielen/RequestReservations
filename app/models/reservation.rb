class Reservation < ActiveRecord::Base
  attr_accessible :reason, :expiration, :requested_at, :status_id, :user_id, :reservation_type, :port
  belongs_to :status
  validates :user_id, :reason, :requested_at, :expiration, :status_id, :reservation_type, :presence => true
end
