class DealerReport < ApplicationRecord
  belongs_to :dealer

  validates :reported_on, presence: true
end
