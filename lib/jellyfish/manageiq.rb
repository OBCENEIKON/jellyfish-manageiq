require 'jellyfish/provisioner'
require 'jellyfish/manageiq/provisioner'
require 'jellyfish/manageiq/engine'
require 'jellyfish/manageiq/storage'
require 'jellyfish/manageiq/big_data'
require 'jellyfish/manageiq/databases'
require 'jellyfish/manageiq/infrastructure'

module Jellyfish
  module ManageIQ
    def self.miq_settings
      # Note for miq_ssl below:
      # On OS/X, for development only, it may be easiest just to disable certificate verification because the
      # certificates are stored in the keychain, not the file system.
      # https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
      {
        miq_url: ENV.fetch('MIQ_URL'),
        miq_username: ENV.fetch('MIQ_USERNAME'),
        miq_password: ENV.fetch('MIQ_PASSWORD'),
        miq_user_email: ENV.fetch('MIQ_USER_EMAIL', 'miq@' + ::URI.parse(ENV.fetch('MIQ_URL')).host),
        miq_user_token: ENV.fetch('MIQ_USER_TOKEN', 'jellyfish-token'),
        miq_referer: ENV.fetch('MIQ_REFERER', ENV.fetch('DEFAULT_URL') + '/api/v1/manageiq/order_item/update_provision'),
        miq_ssl: (::Rails.env.development? && ::OpenSSL::SSL::VERIFY_NONE) || ENV.fetch('MIQ_SSL', ::OpenSSL::SSL::VERIFY_PEER)
      }
    end

    def self.aws_settings
      {
        aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
      }
    end
  end
end
