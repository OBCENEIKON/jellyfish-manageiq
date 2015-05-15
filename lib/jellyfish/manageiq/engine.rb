module Jellyfish
  module ManageIQ
    class Engine < ::Rails::Engine
      engine_name 'jellyfish_manageiq' # For identification in rake tasks

      config.autoload_paths += %W(#{config.root}/lib)

      # This lets our migrations run with a simple rake db:migrate from the app
      # http://pivotallabs.com/leave-your-migrations-in-your-rails-engines/
      initializer :append_migrations do |app|
        unless app.root.to_s == root.to_s
          config.paths['db/migrate'].expanded.each do |expanded_path|
            app.config.paths['db/migrate'] << expanded_path
          end
        end
      end
    end
  end
end
