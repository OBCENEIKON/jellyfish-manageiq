class ManageIQ < Jellyfish::Provisioner
  def provision
    Delayed::Worker.logger.debug("Miq settings url = #{miq_settings[:url]}")
    miq_provision
  end

  private

  def miq_provision
    order_item.provision_status = :unknown
    order_item.payload_request = payload
    order_item.save!

    handle_response
  end

  def service_catalog_id
    # order_item.product.provisionable.service_catalog_id
    1
  end

  def handle_response
    path = "api/service_catalogs/#{service_catalog_id}/service_templates"
    response = request[path].post(payload.to_json, content_type: 'application/json')

    begin
      populate_order_item_with_respose_data(response)
    rescue => e
      order_item.provision_status = :unknown
      order_item.payload_acknowledgement = {
        error: e.try(:response) || 'Request Timeout',
        message: e.try(:message) || "Action response was out of bounds, or something happened that wasn't expected"
      }

      raise e
    ensure
      order_item.save!
    end

    order_item
  end

  def status_from_response_code(code)
    case code
    when 200..299
      :pending
    when 400..407
      :critical
    else
      :warning
    end
  end

  def populate_order_item_with_respose_data(response)
    data = ActiveSupport::JSON.decode(response.body)
    order_item.payload_acknowledgement = data
    order_item.provision_status = status_from_response_code(response.code)
    order_item.miq_id = data['results'][0]['id'] if (200..299).cover?(response.code)
  end

  def payload
    {
      action: 'order',
      resource: {
        href: "#{miq_settings[:url]}/api/service_templates/1", # TODO: Hard coded id because it referenced defunct provisionable
        referer: ENV['DEFAULT_URL'], # TODO: Move this into a manageiq setting
        email: miq_settings[:email],
        token: miq_settings[:token],
        order_item: {
          id: order_item.id,
          uuid: order_item.uuid.to_s,
          product_details: order_item.answers
        }
      }
    }
  end

  def request
    # On OS/X, for development only, it may be easiest just to disable certificate verification because the certificates are stored in the keychain, not the file system
    # https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
    ssl_verify = ManageIQClient.verify_ssl

    RestClient::Resource.new(
      miq_settings[:url],
      user: miq_settings[:username],
      password: miq_settings[:password],
      verify_ssl: ssl_verify,
      timeout: 120,
      open_timeout: 60
    )
  end

  def miq_settings
    @miq_settings = {}
    @miq_settings[:url] = ENV['MIQ_URL']
    @miq_settings[:username] = ENV['MIQ_USERNAME']
    @miq_settings[:password] = ENV['MIQ_PASSWORD']
    @miq_settings[:email] = ENV['MIQ_USER_EMAIL']
    @miq_settings[:token] = ENV['MIQ_USER_TOKEN']
    @miq_settings
  end
end
