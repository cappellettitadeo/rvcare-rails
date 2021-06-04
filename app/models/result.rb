# frozen_string_literal: true

class Result < ApplicationRecord
  belongs_to :dealer
  belongs_to :partner_report

  validates :reported_on, presence: true, uniqueness: { scope: %i[partner_report_id dealer_id] }
end
