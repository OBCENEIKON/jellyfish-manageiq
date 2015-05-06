class Manageiq < ::ActiveRecord::Base
  # Includes
  acts_as_paranoid

  self.table_name = 'order_items'

  # Relationships
  belongs_to :product

  # Hooks
  after_commit :provision, on: :create

  # Columns
  enum provision_status: { ok: 0, warning: 1, critical: 2, unknown: 3, pending: 4, retired: 5 }

  delegate :provisioner, to: :product

  private

  def provision
    provisioner.delay(queue: 'provision_request').provision(id)
  end
end
