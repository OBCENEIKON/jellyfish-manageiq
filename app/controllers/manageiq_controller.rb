class ManageiqController < ApplicationController
  before_action :load_order_item, only: [:start_service, :stop_service]
  before_action :load_order_item_for_provision_update, only: [:provision_update]

  api :PUT, '/manageiq/order_items/:id/start_service', 'Starts service for order item'
  param :id, :number, required: true

  def start_service
    authorize OrderItem
    # TODO: Direct ManageIQ to pass along a start request
    render nothing: true, status: :ok
  end

  api :PUT, '/manageiq/order_items/:id/stop_service', 'Stops service for order item'
  param :id, :number, required: true

  def stop_service
    authorize OrderItem
    # TODO: Direct ManageIQ to pass along a stop request
    render nothing: true, status: :ok
  end

  api :PUT, '/manageiq/order_items/:id/retire_service'
  param :id, :number, required: true

  def retire_service
    order_item = OrderItem.find(params[:id])
    authorize order_item
    order_item.product.product_type.provisioner.delay(queue: 'retire_request').retire
    render nothing: true, status: :ok
  end

  api :PUT, '/manageiq/order_items/:id/provision_update', 'Updates an order item from ManageIQ'
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

    ignore = %w(uuid order_item provision_status)
    params[:info].each do |key, value|
      next if ignore.include?(key) || value.blank?
      @order_item.provision_derivations.build(order_item_id: params[:id], name: key, value: value)
    end

    @order_item.update_attributes order_item_params_for_provision_update
    respond_with @order_item
  end

  private

  def order_item_params
    params.permit(:uuid, :hourly_price, :monthly_price, :setup_price)
  end

  def load_order_item
    @order_item = OrderItem.find params.require(:id)
  end

  def order_item_params_for_provision_update
    params.require(:info).permit(:miq_id, :provision_status).merge(payload_response: ActionController::Parameters.new(JSON.parse(request.body.read)))
  end

  def load_order_item_for_provision_update
    @order_item = OrderItem.where(id: params.require(:id), uuid: params.require(:info)[:uuid]).first!
  end
end