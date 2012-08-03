class CreateCommunications < ActiveRecord::Migration
  def change
    create_table :communications do |t|
      t.string :name
      t.string :method
      t.string :value

      t.timestamps
    end
  end
end
