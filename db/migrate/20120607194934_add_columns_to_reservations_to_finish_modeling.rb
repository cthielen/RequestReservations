class AddColumnsToReservationsToFinishModeling < ActiveRecord::Migration
  def change
    rename_column :reservations, :requested, :requested_at
    add_column :reservations, :type, :integer
    add_column :reservations, :ip_address, :string
    add_column :reservations, :port, :string
  end
end
