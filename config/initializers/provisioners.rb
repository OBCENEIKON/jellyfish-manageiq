require 'jellyfish/manageiq/storage'
require 'jellyfish/manageiq/big_data'
require 'jellyfish/manageiq/databases'
require 'jellyfish/manageiq/infrastructure'

Rails.application.config.x.provisioners.merge!(
  JSON.parse(File.read(Jellyfish::ManageIQ::Engine.root.join('config', 'provisioners.json')))
    .map { |product_type, provisioner| [product_type, provisioner.constantize] }.to_h
)
