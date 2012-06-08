class RenameReservationDescriptionToReason < ActiveRecord::Migration
  def change
    rename_column :reservations, :description, :reason
  end
end
