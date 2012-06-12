class AddOptionalSysaidIdToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :sysaid_id, :integer
  end
end
