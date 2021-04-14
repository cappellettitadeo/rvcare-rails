# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WellsFargoReport, type: :model do
  subject(:report) { create(:wells_fargo_report, :with_sales_entries, monthly_value: monthly_value) }

  let(:entry) { report.sales.first }
  let(:dealer) { entry.dealer }
  let(:monthly_value) { 0 }

  let(:multiplier_one) { 0.0 }
  let(:threshold_one) { 155_000_000 }
  let(:multiplier_two) { 0.0002 }
  let(:threshold_two) { 180_000_000 }
  let(:multiplier_three) { 0.0003 }
  let(:threshold_three) { 205_000_000 }
  let(:multiplier_four) { 0.0004 }
  let(:threshold_four) { 230_000_000 }
  let(:multiplier_five) { 0.0005 }
  let(:threshold_five) { 305_000_000 }
  let(:multiplier_six) { 0.0006 }
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

  context 'creates with default parameters' do
    subject(:report) { create(:wells_fargo_report, parameters: {}) }

    it { is_expected.to be_valid }
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
      let(:monthly_value) { threshold_three / 12 }
      let(:multiplier) { multiplier_three }

      it_behaves_like :tier_total
    end

    context 'tier four' do
      let(:monthly_value) { threshold_four / 12 }
      let(:multiplier) { multiplier_four }

      it_behaves_like :tier_total
    end

    context 'tier five' do
      let(:monthly_value) { threshold_five / 12 }
      let(:multiplier) { multiplier_five }

      it_behaves_like :tier_total
    end

    context 'tier six' do
      let(:monthly_value) { (threshold_five + 12) / 12 }
      let(:multiplier) { multiplier_six }

      it_behaves_like :tier_total
    end
  end

  describe '#dealer_share' do
    let(:monthly_value) { (threshold_five + 12) / 12 }

    it 'calculates dealer share' do
      expect(report.calculate_total_dealer_share).to eq((report.calculate_total_return_amount * dealer_share_multiplier).round)
    end
  end
end
