class AddCancelledStatusToReservations < ActiveRecord::Migration
  def up
    Authorization.ignore_access_control(true)
    s = Status.new
    s.label = "Cancelled"
    s.save
  end

  def down
    Authorization.ignore_access_control(true)
    s = Status.find_by_label("Cancelled")
    unless s.nil?
      s.delete
    end
  end
end
