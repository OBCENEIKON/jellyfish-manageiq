class ManageiqPolicy < ::ApplicationPolicy
  def start_service?
    admin_or_related
  end

  def stop_service?
    admin_or_related
  end

  def retire_service?
    admin_or_related
  end

  def provision_update?
    user.admin?
  end

  private

  def admin_or_related
    user.admin? || user.project_ids.include?(record.project_id)
  end
end
