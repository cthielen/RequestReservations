class AddSubnetIdToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :subnet_id, :integer
  end
end
