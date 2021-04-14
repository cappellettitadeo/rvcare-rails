# frozen_string_literal: true

class Entry < ApplicationRecord
  belongs_to :partner_report
  belongs_to :dealer

  validates :reported_on, uniqueness: { scope: %i[dealer_id partner_report_id type] }
end
