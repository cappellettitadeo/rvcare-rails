# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SimpleSalesReport, type: :model do
  subject(:report) { create(:simple_sales_report, :with_sales_entries) }

  let(:entry) { report.entries.first }
  let(:dealer) { entry.dealer }

  let(:sales_multiplier) { 0.01 }
  let(:dealer_share_multiplier) { 0.6 }

  describe '#total' do
    it 'calculates return' do
      expect(report.calculate_total_return_amount).to eq(report.sales.sum(&:value) * sales_multiplier)
    end
  end

  describe '#dealer_share' do
    it 'calculates dealer share' do
      expect(report.calculate_total_dealer_share).to eq(report.calculate_total_return_amount * dealer_share_multiplier)
    end
  end
end
