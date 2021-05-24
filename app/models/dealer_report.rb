# frozen_string_literal: true

class DealerReport < ApplicationRecord
  belongs_to :dealer

  validates :reported_on, presence: true
end
