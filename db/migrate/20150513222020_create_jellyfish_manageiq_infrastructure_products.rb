class CreateJellyfishManageiqInfrastructureProducts < ActiveRecord::Migration
  def change
    create_table :jellyfish_manageiq_infrastructure_products do |t|
      t.timestamps
      t.string :cloud_provider
      t.string :chef_role
      t.integer :service_catalog_id
      t.integer :service_template_id
      t.string :instance_size
      t.float :disk_size
    end
  end
end
