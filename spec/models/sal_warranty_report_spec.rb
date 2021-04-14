# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SalWarrantyReport, type: :model do
  subject(:report) { create(:sal_warranty_report, :with_unit_entries) }

  let(:entry) { report.entries.first }
  let(:dealer) { entry.dealer }

  let(:contract_value) { 27 }
  let(:bonus_value) { 25 }
  let(:dealer_share_value) { 25 }
  let(:new_dealer_value) { 37 }
  let(:new_dealer_date_cutoff) { '2019-01-01' }
  let(:new_dealer_bonus_months) { 12 }

  describe '#total' do
    it 'calculates return' do
      expect(report.calculate_total_return_amount).to eq(report.units.sum(:value) * (contract_value + bonus_value))
    end

    context 'new dealer more than 6 months' do
      let(:new_dealer_bonus_units) { report.units.where('dealer_id = ? AND reported_on < ?', dealer.id, new_dealer_end_date).sum(:value) }
      let(:new_dealer_regular_units) { report.units.where('dealer_id = ? AND reported_on >= ?', dealer.id, new_dealer_end_date).sum(:value) }
      let(:regular_units) { report.units.where.not(dealer: dealer).sum(:value) + new_dealer_regular_units }
      let(:new_dealer_total_value) { new_dealer_value + bonus_value }
      let(:regular_total_value) { contract_value + bonus_value }
      let(:date_joined) { Date.new(report.year - 1, 6, 1) }
      let(:new_dealer_end_date) { date_joined + 12.months }
      let(:new_dealer_total) { new_dealer_bonus_units * new_dealer_total_value }
      let(:regular_total) { regular_units * regular_total_value }

      before do
        dealer.date_joined = date_joined
        dealer.save!
      end

      it 'calculates return' do
        expect(report.calculate_total_return_amount).to eq(new_dealer_total + regular_total)
      end
    end
  end

  describe '#dealer_share' do
    it 'calculates dealer share' do
      expect(report.calculate_total_dealer_share).to eq(report.units.sum(:value) * dealer_share_value)
    end
  end
end
