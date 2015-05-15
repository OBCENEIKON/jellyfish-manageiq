class ProvisionItem < ::ActiveRecord::Base
  # Includes
  # acts_as_paranoid

  # Relationships
  belongs_to :order_item

  # Validations
  validates :product, presence: true
  validate :validate_product_id

  # Columns
  enum provision_status: { ok: 0, warning: 1, critical: 2, unknown: 3, pending: 4, retired: 5 }
end
