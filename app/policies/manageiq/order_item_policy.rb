module Manageiq
  class OrderItemPolicy < ::OrderItemPolicy
    def start_service?
      admin_or_related
    end

    def stop_service?
      admin_or_related
    end

    def provision_update?
      ap user
      user.admin?
    end
  end
end
