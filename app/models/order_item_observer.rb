class OrderItemObserver < ActiveRecord::Observer
  def after_commit(order_item)
    @order_item = order_item

    order_item.product.product_type.provisioner.delay(queue: 'provision_request').provision(@order_item.id) if action == :create
  end

  private

  def action
    @order_item.created_at === @order_item.updated_at ? :create : :update
  end
end
