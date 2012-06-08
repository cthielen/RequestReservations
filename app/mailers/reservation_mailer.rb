class ReservationMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def new_reservation(reservation)
    @reservation = reservation
    mail(:to => "something@example.com", :subject => "New Reservation Request")
  end
end
