class Reservation < ActiveRecord::Base
  using_access_control
  attr_accessible :reason, :expiration, :requested_at, :status_id, :loginid, :reservation_type, :port, :ip_address, :subnet_id
  belongs_to :status
  belongs_to :subnet
  validates :loginid, :reason, :requested_at, :expiration, :status_id, :reservation_type, :presence => true

  def reservation_type_in_words
    if reservation_type == 0
      "Static IP"
    else
      "Firewall Exemption"
    end
  end
end
