class ReservationMailer < ActionMailer::Base
  default from: "no-reply@#{ActionMailer::Base.default_url_options[:host]}"

  def new_reservation(reservation)
    @reservation = reservation
    Alert.where(:method => "E-Mail").each do |alert|
      mail(:to => alert.value, :subject => "New Reservation Request")
    end
  end
end
