class DropCreatedAtAndUpdatedAtFromStatusTable < ActiveRecord::Migration
  def change
    remove_column :statuses, :created_at
    remove_column :statuses, :updated_at
  end
end
