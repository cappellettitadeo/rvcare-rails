# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SimpleUnitsReport, type: :model do
  subject(:report) { create(:simple_units_report, :with_unit_entries) }

  let(:entry) { report.entries.first }
  let(:dealer) { entry.dealer }

  let(:contract_value) { 2 }
  let(:dealer_share_multiplier) { 0.6 }

  describe '#total' do
    it 'calculates return' do
      expect(report.calculate_total_return_amount).to eq(report.units.sum(&:value) * contract_value)
    end
  end

  describe '#dealer_share' do
    it 'calculates dealer share' do
      expect(report.calculate_total_dealer_share).to eq((report.calculate_total_return_amount * dealer_share_multiplier).round)
    end
  end
end
