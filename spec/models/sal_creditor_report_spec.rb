# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SalCreditorReport, type: :model do
  subject(:report) {
    create(:sal_creditor_report, :with_sal_entries,
           monthly_value: monthly_value, monthly_units: monthly_units)
  }

  let(:monthly_value) { endorsement_threshold / 12 }
  let(:monthly_units) { (monthly_value * max_multiplier / endorsement_fee).round - 1 }
  let(:endorsement_threshold) { endorsement_one_threshold }
  let(:max_multiplier) { endorsement_one_max_multiplier }
  let(:endorsement_fee) { endorsement_one_value }

  let(:contract_value) { 50 }
  let(:endorsement_one_value) { 50 }
  let(:endorsement_one_max_multiplier) { 0.012 }
  let(:endorsement_one_threshold) { 13_000_000 }
  let(:endorsement_two_value) { 55 }
  let(:endorsement_two_max_multiplier) { 0.0125 }
  let(:endorsement_two_threshold) { 14_000_000 }
  let(:endorsement_three_value) { 60 }
  let(:endorsement_three_max_multiplier) { 0.013 }
  let(:endorsement_three_threshold) { 15_000_000 }
  let(:endorsement_four_value) { 65 }
  let(:endorsement_four_max_multiplier) { 0.0135 }
  let(:dealer_share_multiplier) { 0.01 }
  let(:new_dealer_date_cutoff) { '2019-01-01' }
  let(:new_dealer_value) { 95 }
  let(:new_dealer_max_multiplier) { 0.0225 }

  let(:entry) { report.entries.first }
  let(:dealer) { entry.dealer }

  shared_examples_for :tier_total do
    let(:monthly_value) { endorsement_threshold / 12 }

    context 'below multiplier amount' do
      let(:monthly_units) { (monthly_value * max_multiplier / endorsement_fee).round - 1 }

      it 'calculates return' do
        contract_total = report.units.sum(:value) * contract_value
        endorsement_total = report.units.sum(:value) * endorsement_fee

        expect(report.calculate_total_return_amount).to eq(contract_total + endorsement_total)
      end
    end

    context 'above multiplier amount' do
      let(:monthly_units) { (monthly_value * max_multiplier / endorsement_fee).round + 1 }

      it 'calculates return' do
        contract_total = report.units.sum(:value) * contract_value
        endorsement_total = report.sales.sum(:value) * max_multiplier

        expect(report.calculate_total_return_amount).to eq((contract_total + endorsement_total).round)
      end
    end
  end

  describe '#calculate_total_return_amount' do
    context 'new dealers' do
      let(:endorsement_threshold) { endorsement_one_threshold }
      let(:max_multiplier) { new_dealer_max_multiplier }
      let(:endorsement_fee) { new_dealer_value }

      before do
        report
        Dealer.update_all(date_joined: Date.parse(new_dealer_date_cutoff))
      end

      it_behaves_like :tier_total
    end

    context 'tier one' do
      let(:endorsement_threshold) { endorsement_one_threshold }
      let(:max_multiplier) { endorsement_one_max_multiplier }
      let(:endorsement_fee) { endorsement_one_value }

      it_behaves_like :tier_total
    end

    context 'tier two' do
      let(:endorsement_threshold) { endorsement_two_threshold }
      let(:max_multiplier) { endorsement_two_max_multiplier }
      let(:endorsement_fee) { endorsement_two_value }

      it_behaves_like :tier_total
    end

    context 'tier three' do
      let(:endorsement_threshold) { endorsement_three_threshold }
      let(:max_multiplier) { endorsement_three_max_multiplier }
      let(:endorsement_fee) { endorsement_three_value }

      it_behaves_like :tier_total
    end

    context 'above last tier' do
      let(:endorsement_threshold) { endorsement_three_threshold + 12 }
      let(:max_multiplier) { endorsement_four_max_multiplier }
      let(:endorsement_fee) { endorsement_four_value }

      it_behaves_like :tier_total
    end
  end

  describe '#dealer_share' do
    it 'calculates dealer share' do
      expect(report.calculate_total_dealer_share).to eq((report.sales.sum(:value) * dealer_share_multiplier).round)
    end
  end
end
