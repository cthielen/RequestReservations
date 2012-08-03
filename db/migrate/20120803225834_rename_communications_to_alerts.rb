class RenameCommunicationsToAlerts < ActiveRecord::Migration
  def change
    rename_table :communications, :alerts
  end
end
