require 'jellyfish/manageiq/engine'
require 'delayed_job_active_record'
require 'delayed/performable_mailer'

module Jellyfish
  module ManageIQ
    def self.root
      File.expand_path('../..', __FILE__)
    end
  end
end
