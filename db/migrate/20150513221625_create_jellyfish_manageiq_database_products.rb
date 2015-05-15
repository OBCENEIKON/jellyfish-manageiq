class CreateJellyfishManageiqDatabaseProducts < ActiveRecord::Migration
  def change
    create_table :jellyfish_manageiq_database_products do |t|
      t.timestamps
      t.string :cloud_provider
      t.string :chef_role
      t.integer :service_catalog_id
      t.integer :service_template_id
      t.string :db_instance_class
      t.string :engine
      t.float :allocated_storage
      t.string :storage_type
      t.string :availability
    end
  end
end
