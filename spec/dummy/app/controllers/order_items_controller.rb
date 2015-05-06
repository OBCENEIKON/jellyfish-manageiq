class OrderItemsController < ApplicationController
  before_action :load_order_item, only: :show

  def show
    # require RenderWithParams

    # respond_with_params @order_item
    # respond_with @order_item
    render json: @order_item
  end

  private

  def order_item_params
    params.permit(:uuid, :hourly_price, :monthly_price, :setup_price)
  end

  def load_order_item
    @order_item = OrderItem.find params.require(:id)
  end
end
