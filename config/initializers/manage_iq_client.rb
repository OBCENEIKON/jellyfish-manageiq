if ENV['MIQ_URL']
  ManageIQClient.host = ENV['MIQ_URL']

  if Rails.env.development?
    ManageIQClient.verify_ssl = OpenSSL::SSL::VERIFY_NONE
  elsif ENV['MIQ_SSL'].nil?
    ManageIQClient.verify_ssl = OpenSSL::SSL::VERIFY_PEER
  else
    ManageIQClient.verify_ssl = ENV['MIQ_SSL']
  end

  if ENV['MIQ_USERNAME'] && ENV['MIQ_PASSWORD']
    ManageIQClient.credentials = { user: ENV['MIQ_USERNAME'], password: ENV['MIQ_PASSWORD'] }
  end
end
