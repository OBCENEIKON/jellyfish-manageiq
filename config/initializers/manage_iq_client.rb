if ENV['MIQ_URL']
  ManageIQClient.host = ENV['MIQ_URL']

  ManageIQClient.verify_ssl = (::Rails.env.development? && ::OpenSSL::SSL::VERIFY_NONE) || ENV.fetch('MIQ_SSL', ::OpenSSL::SSL::VERIFY_PEER)

  if ENV['MIQ_USERNAME'] && ENV['MIQ_PASSWORD']
    ManageIQClient.credentials = { user: ENV['MIQ_USERNAME'], password: ENV['MIQ_PASSWORD'] }
  end
end
