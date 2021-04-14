# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EastPennReport, type: :model do
  subject(:report) { create(:east_penn_report, :with_sales_entries, monthly_value: monthly_value) }

  let(:entry) { report.entries.first }
  let(:dealer) { entry.dealer }
  let(:monthly_value) { 0 }

  let(:multiplier_one) { 0.075 }
  let(:threshold_one) { 1_500_000 }
  let(:multiplier_two) { 0.08 }
  let(:threshold_two) { 1_700_000 }
  let(:multiplier_three) { 0.085 }
  let(:dealer_share_multiplier) { 0.6 }

  shared_examples_for :tier_total do
    it 'calculates return' do
      expect(report.calculate_total_return_amount).to eq((report.sales.sum(&:value) * multiplier).round)
    end

    it 'calculates correct total from dealer' do
      report.sales.map(&:dealer).uniq.each do |dealer|
        expect(report.calculate_total_return_amount(dealer: dealer)).to eq((report.sales.where(dealer: dealer).sum(&:value) * multiplier).round)
      end
    end
  end

  describe '#total' do
    context 'tier one' do
      let(:monthly_value) { threshold_one / 12 }
      let(:multiplier) { multiplier_one }

      it_behaves_like :tier_total
    end

    context 'tier two' do
      let(:monthly_value) { threshold_two / 12 }
      let(:multiplier) { multiplier_two }

      it_behaves_like :tier_total
    end

    context 'tier three' do
      let(:monthly_value) { (threshold_two + 12) / 12 }
      let(:multiplier) { multiplier_three }

      it_behaves_like :tier_total
    end
  end

  describe '#dealer_share' do
    it 'calculates dealer share' do
      expect(report.calculate_total_dealer_share).to eq(report.calculate_total_return_amount * dealer_share_multiplier)
    end
  end
end
