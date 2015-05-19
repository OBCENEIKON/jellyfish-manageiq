require 'dotenv/tasks'

# namespace :jellyfish do
#   namespace :manageiq do
#     desc 'Poll ManageIQ VMS'
#     task pollvms: [:dotenv, :environment] do
#       # setup metadata
#       vm_list = ManageIQClient::VirtualMachine.list
#       miq_path = ManageIQClient.host + ManageIQClient::VirtualMachine.path + '/'
#
#       # get the ids of each resource
#       resource_ids = []
#       unless vm_list['resources'].nil?
#         vm_list['resources'].each do |resource_path|
#           if resource_path['href'].index(miq_path) == 0
#             resource_id = resource_path['href'][miq_path.length, resource_path['href'].length].to_i
#             resource_ids << resource_id
#           end
#         end
#         resource_ids = resource_ids.sort
#       end
#
#       # poll each vm and create alerts for power off state
#       resource_ids.each do |resource_id|
#         vm_info = ManageIQClient::VirtualMachine.find resource_id
#         message_status = (vm_info[:power_state] == 'on') ? 'OK' : 'WARNING'
#         message = message_status + ': ' + 'The VM resource with ID ' + resource_id.to_s + " is in the '" + vm_info[:power_state] + "' state."
#         alert_params = { project_id: '0', staff_id: '0', order_item_id: resource_id, status: message_status, message: message, start_date: Time.zone.now.to_s }
#         conditions = { project_id: alert_params[:project_id], order_item_id: alert_params[:order_item_id], status: alert_params[:status] }
#         result = ::Alert.where(conditions).order('updated_at DESC').first
#         alert_id = (result.nil? || result.id.nil?) ? nil : result.id
#         if alert_id.nil? # CAN CREATE AS NEW
#           result = ::Alert.new alert_params
#         else # UPDATE THE ATTRIBUTE - UPDATE ID
#           result.update_attributes alert_params
#         end
#         result.save
#         puts message
#       end
#     end
#   end
# end
