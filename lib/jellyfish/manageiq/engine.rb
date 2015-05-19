module Jellyfish
  module ManageIQ
    class Engine < ::Rails::Engine
      engine_name 'jellyfish_manageiq' # For identification in rake tasks

      config.autoload_paths += %W(#{config.root}/lib)
    end
  end
end
