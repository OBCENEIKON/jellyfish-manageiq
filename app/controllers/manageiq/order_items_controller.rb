module Manageiq
  class OrderItemsController < ::ApplicationController
    after_action :verify_authorized

    before_action :load_order_item, only: [:start_service, :stop_service]
    before_action :load_order_item_for_update, only: :provision_update

    api :PUT, '/manageiq/order_item/:order_item_id/start_service', 'Starts service for a provisioned order item'
    param :id, :number, required: true

    def start_service
      authorize OrderItem
      # TODO: Direct ManageIQ to pass along a start request
      render nothing: true, status: :ok
    end

    api :PUT, '/manageiq/order_item/:id/stop_service', 'Stops service for a provisioned order item'
    param :id, :number, required: true

    def stop_service
      authorize OrderItem
      # TODO: Direct ManageIQ to pass along a stop request
      render nothing: true, status: :ok
    end

    api :PUT, '/manageiq/order_item/:id/retire_service'
    param :id, :number, required: true

    def retire_service
      order_item = OrderItem.find(params[:id])
      authorize order_item
      order_item.provisioner.delay(queue: 'retire_request').retire
      render nothing: true, status: :ok
    end

    api :PUT, '/manageiq/order_item/:id/provision_update', 'Updates a provisioned order item from ManageIQ'
    param :id, :number, required: true, desc: 'Order Item ID'
    param :status, String, required: true, desc: 'Status of the provision request'
    param :message, String, required: true, desc: 'Any messages from ManageIQ'
    param :info, Hash, required: true, desc: 'Informational payload from ManageIQ' do
      param :uuid, String, required: true, desc: 'V4 UUID Generated for order item upon creation'
      param :provision_status, String, required: true, desc: 'Status of the provision request'
      param :miq_id, :number, required: false, desc: 'The unique ID from ManageIQ'
    end

    error code: 404, desc: MissingRecordDetection::Messages.not_found
    error code: 422, desc: ParameterValidation::Messages.missing

    def provision_update
      authorize @order_item

      @order_item.update_attributes order_item_params_for_update
      respond_with @order_item
    end

    private

    def order_item_params
      params.permit(:uuid)
    end

    def load_order_item
      @order_item = OrderItem.find params.require(:id)
    end

    def order_item_params_for_update
      params.require(:info).permit(:miq_id, :provision_status).merge(payload_response: ActionController::Parameters.new(JSON.parse(request.body.read)))
    end

    def load_order_item_for_update
      @order_item = OrderItem.where(id: params.require(:id), uuid: params.require(:info)[:uuid]).first!
    end
  end
end
