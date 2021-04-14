# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NtpReport, type: :model do
  subject(:report) { create(:ntp_report, :with_sales_entries, monthly_value: monthly_value) }

  let(:entry) { report.sales.first }
  let(:dealer) { entry.dealer }
  let(:threshold) { 13_500_000 }
  let(:first_tier_multiplier) { 0.0075 }
  let(:second_tier_multiplier) { 0.01 }
  let(:monthly_value) { threshold / 12 }

  context 'creates with default parameters' do
    subject(:report) { create(:ntp_report, parameters: {}) }

    it { is_expected.to be_valid }
  end

  describe '#total' do
    context 'below threshold' do
      it 'calculates return' do
        expect(report.calculate_total_return_amount).to eq(report.sales.sum(&:value) * first_tier_multiplier)
      end
    end

    context 'above threshold' do
      let(:over_threshold) { 500_000 }
      let(:monthly_value) { (threshold + over_threshold) / 12 }

      it 'calculates return' do
        expect(report.calculate_total_return_amount).to eq(threshold * first_tier_multiplier + over_threshold * second_tier_multiplier)
      end
    end
  end

  describe '#dealer_share' do
    it 'gives dealers 0' do
      expect(report.calculate_total_dealer_share).to eq(0)
    end
  end
end
