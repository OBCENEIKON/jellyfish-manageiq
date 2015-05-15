module Jellyfish
  module ManageIQ
    class Provisioner < Jellyfish::Provisioner
      def provision
        @miq_settings = Jellyfish::ManageIQ.miq_settings

        provision_path = "api/service_catalogs/#{service_catalog_id}/service_templates"
        provision_url = "#{@miq_settings[:miq_url]}/api/service_templates/#{service_template_id}"

        @order_item.provision_status = :unknown
        @order_item.payload_request = payload('order', provision_url)
        @order_item.save!

        handle_response(provision_path)
      end

      def retire
        @miq_settings = Jellyfish::ManageIQ.miq_settings

        retire_path = "api/services/#{instance_id}"
        retire_url = "#{@miq_settings[:miq_url]}/#{retire_path}"

        @order_item.provision_status = :unknown
        @order_item.payload_request = payload('retire', retire_url)
        @order_item.save!

        handle_response(retire_path)

        @order_item.provision_status = 'retired'
        @order_item.save!
      end

      private

      def service_catalog_id
        @order_item.answers['ServiceCatalogId'].to_i
      end

      def service_template_id
        @order_item.answers['ServiceTemplateId'].to_i
      end

      def instance_id
        @order_item.miq_id
      end

      def handle_response(path)
        response = request[path].post(@order_item.payload_request.to_json, content_type: 'application/json')

        begin
          populate_provision_with_response_data(response)
        rescue => e
          @order_item.provision_status = :unknown
          @order_item.payload_acknowledgement = {
            error: e.try(:response) || 'Request Timeout',
            message: e.try(:message) || "Action response was out of bounds, or something happened that wasn't expected"
          }

          raise e
        ensure
          @order_item.save!
        end

        @order_item
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

      def populate_provision_with_response_data(response)
        data = ActiveSupport::JSON.decode(response.body)
        @order_item.payload_acknowledgement = data
        @order_item.provision_status = status_from_response_code(response.code)
        @order_item.miq_id = data['results'][0]['id'] if (200..299).cover?(response.code)
      end

      def payload(action, url)
        @aws_settings = Jellyfish::ManageIQ.aws_settings
        {
          action: action,
          resource: {
            href: url,
            referer: @miq_settings[:miq_referer] + "/#{@order_item.id}",
            email: @miq_settings[:miq_user_email],
            token: @miq_settings[:miq_user_token],
            order_item: {
              id: @order_item.id,
              uuid: @order_item.uuid.to_s,
              product_details: @order_item.answers.merge(access_key_id: @aws_settings[:aws_access_key_id], secret_access_key: @aws_settings[:aws_secret_access_key])
            }
          }
        }
      end

      def request
        RestClient::Resource.new(
          @miq_settings[:miq_url],
          user: @miq_settings[:miq_username],
          password: @miq_settings[:miq_password],
          verify_ssl: @miq_settings[:miq_ssl],
          timeout: 120,
          open_timeout: 60
        )
      end
    end
  end
end
