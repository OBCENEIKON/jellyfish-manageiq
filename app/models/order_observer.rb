# module WatchOrder
#   extend ActiveRecord::Transactions
#
#   def self.included(base)
#     base.extend(ClassMethods)
#   end
#
#   module ClassMethods
#     def bar
#       puts 'class method'
#     end
#   end
#
#   def foo
#     puts 'instance method'
#   end
#
#   def callback_action
#     ap "transaction_include_any_action?(:create): #{transaction_include_any_action?(:create)}"
#   end
# end
#
#
# class OrderObserver < ActiveRecord::Observer
#   include WatchOrder
#
#   def after_commit(order)
#     ap 'Finding order'
#     ap self
#     ap order
#     callback_action
#   end
#
#   # def after_commit(order_item)
#   #   provisioner.delay(queue: 'provision_request').provision(id) if transaction_include_action?(:create)
#   # end
# end
