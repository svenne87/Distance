class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :address
      t.float :longitude
      t.float :latitude
      t.integer :units
      t.boolean :gmaps

      t.timestamps
    end
  end
end
