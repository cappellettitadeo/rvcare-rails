class DealerReport < ApplicationRecord
  belongs_to :dealer

  validates :reported_on, presence: true

  monetize :new_units_volume_cents, :used_units_volume_cents, :service_volume_cents,
    :parts_volume_cents, :creditor_volume_cents, :warranty_volume_cents,
    :other_volume_cents
end
