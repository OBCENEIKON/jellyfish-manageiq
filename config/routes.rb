Rails.application.routes.draw do
  scope '/api/v1' do
    scope 'manageiq', module: 'manageiq' do
      # Automate Routes
      resources :automate, only: [] do
        collection do
          get :catalog_item_initialization
          get :update_servicemix_and_chef
          get :provision_rds

          get :create_ec2
          get :create_rds
          get :create_s3
          get :create_ses
          get :create_vmware_vm
          get :create_chef_node

          get :retire_ec2
          get :retire_rds
          get :retire_s3
          get :retire_ses
          get :retire_vmware_vm
        end
      end

      # Provision Request Response
      # Gives us named routes like manageiq_start_service
      # and route paths like /api/v1/manageiq/order_items/:id/start_service
      namespace :order_items, defaults: { format: :json }, only: :update, as: 'manageiq' do
        scope '/:id' do
          put :start_service
          put :stop_service
          put :provision_update
        end
      end
    end
  end
end
