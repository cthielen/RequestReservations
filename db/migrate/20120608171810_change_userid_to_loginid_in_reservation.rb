class ChangeUseridToLoginidInReservation < ActiveRecord::Migration
  def change
    rename_column :reservations, :user_id, :loginid
    change_column :reservations, :loginid, :string
  end

end
