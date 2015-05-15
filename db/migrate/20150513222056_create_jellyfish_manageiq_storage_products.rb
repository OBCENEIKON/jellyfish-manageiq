class CreateJellyfishManageiqStorageProducts < ActiveRecord::Migration
  def change
    create_table :jellyfish_manageiq_storage_products do |t|
      t.timestamps
      t.string :cloud_provider
      t.string :chef_role
      t.integer :service_catalog_id
      t.integer :service_template_id
      t.string :availability
      t.string :region
    end
  end
end
