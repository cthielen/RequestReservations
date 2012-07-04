class CreateSubnets < ActiveRecord::Migration
  def change
    create_table :subnets do |t|
      t.string :name

      t.timestamps
    end
  end
end
