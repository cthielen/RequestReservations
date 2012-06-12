class AddCancelledStatusToReservations < ActiveRecord::Migration
  def up
    s = Status.new
    s.label = "Cancelled"
    s.save
  end
  
  def down
    s = Status.find_by_label("Cancelled")
    unless s.nil?
      s.delete
    end
  end
end
