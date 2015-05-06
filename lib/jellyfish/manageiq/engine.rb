require 'rails-observers'
require 'jellyfish/provisioner'

# Provisioner = Jellyfish::Provisioner

module Jellyfish
  module ManageIQ
    class Engine < ::Rails::Engine
      config.autoload_paths += %W(#{config.root}/lib)
      config.active_record.observers = :order_item_observer, :alert_observer
    end
  end
end
