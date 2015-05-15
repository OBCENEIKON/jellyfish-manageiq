class CreateJellyfishManageiqBigDataProducts < ActiveRecord::Migration
  def change
    create_table :jellyfish_manageiq_big_data_products do |t|
      t.timestamps
      t.string :cloud_provider
      t.string :chef_role
      t.integer :service_catalog_id
      t.integer :service_template_id
      t.integer :cpu_count
      t.float :disk_size
      t.float :ram_size
    end
  end
end
