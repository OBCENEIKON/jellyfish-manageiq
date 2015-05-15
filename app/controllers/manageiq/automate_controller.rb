module Manageiq
  # Display automate code for ManageIQ / CloudForms
  class AutomateController < ::ApplicationController
    layout false
    def catalog_item_initialization
      render 'manageiq/automate/catalog_item_initialization.html.erb', content_type: :plain
    end

    def update_servicemix_and_chef
      render 'manageiq/automate/update_servicemix_and_chef.html.erb', content_type: :plain
    end

    def create_rds
      render 'manageiq/automate/create_rds.html.erb', content_type: :plain
    end

    def provision_rds
      render 'manageiq/automate/provision_rds.html.erb', content_type: :plain
    end

    def create_ec2
      render 'manageiq/automate/create_ec2.html.erb', content_type: :plain
    end

    def create_s3
      render 'manageiq/automate/create_s3.html.erb', content_type: :plain
    end

    def create_ses
      render 'manageiq/automate/create_ses.html.erb', content_type: :plain
    end

    def retire_ec2
      render 'manageiq/automate/retire_ec2.html.erb', content_type: :plain
    end

    def retire_rds
      render 'manageiq/automate/retire_rds.html.erb', content_type: :plain
    end

    def retire_s3
      render 'manageiq/automate/retire_s3.html.erb', content_type: :plain
    end

    def retire_ses
      render 'manageiq/automate/retire_ses.html.erb', content_type: :plain
    end

    def create_vmware_vm
      render 'manageiq/automate/create_vmware_vm.html.erb', content_type: :plain
    end

    def retire_vmware_vm
      render 'manageiq/automate/retire_vmware_vm.html.erb', content_type: :plain
    end

    def create_chef_node
      render 'manageiq/automate/create_chef_node.html.erb', content_type: :plain
    end
  end
end
