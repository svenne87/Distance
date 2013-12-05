class AddGmapFieldToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :gmap, :boolean
  end
end
