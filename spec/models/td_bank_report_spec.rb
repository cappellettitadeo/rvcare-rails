# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TdBankReport, type: :model do
  subject(:report) { create(:td_bank_report, :with_td_unit_entries) }

  let(:entry) { report.units.first }

  let(:dealer) { entry.dealer }

  let(:contract_value) { 51 }

  let(:market_share_reached_extra) { 31 }

  let(:first_look_extra) { 31 }

  let(:total_value) { contract_value + first_look_extra + market_share_reached_extra }

  let(:dealer_share_multiplier) { 0.6 }

  context 'creates with default parameters' do
    subject(:report) { create(:td_bank_report, parameters: {}) }

    it { is_expected.to be_valid }
  end

  it 'validates parameters schema' do
    expect(build(:td_bank_report, parameters: { aaa: 'aa' })).not_to be_valid
    expect(build(:td_bank_report, parameters: { contract_value: 123, market_share_reached_extra: 11, first_look_extra: 11, dealer_share_multiplier: 32 })).to be_valid
  end

  describe '#total_return_amount' do
    context 'with a month that did not reach market share' do
      let(:actual_total_return) { report.units.sum(&:value) * total_value - (entry.value * market_share_reached_extra) }
      let(:average_total_value) { actual_total_return.to_f / report.units.sum(&:value) }

      let(:extra) {
        {
          'market_share_reached' => false,
          'first_look' => true
        }
      }

      before do
        entry.extra['market_share_reached'] = false
        entry.save!
      end

      it 'calculates return' do
        expect(report.calculate_total_return_amount).to eq(actual_total_return)
      end

      it 'calculates total for dealer' do
        expect(report.calculate_total_return_amount(dealer: dealer)).to eq((report.units.where(dealer: dealer).sum(&:value) * average_total_value).round)
      end
    end

    context 'with a month that did not reach first_look share' do
      let(:extra) {
        {
          'market_share_reached' => true,
          'first_look' => false
        }
      }

      before do
        entry.extra['first_look'] = false
        entry.save!
      end

      it 'calculates return' do
        expect(report.calculate_total_return_amount).to eq(report.units.sum(&:value) * total_value - (entry.value * first_look_extra))
      end
    end

    it 'calculates return' do
      expect(report.calculate_total_return_amount).to eq(report.units.sum(&:value) * total_value)
    end

    it 'calculates total for range' do
      range_start = Date.new(report.year, 1, 1)
      range_end = range_start.end_of_month
      expect(report.calculate_total_return_amount(reported_on: range_start..range_end)).to eq(report.units.where(reported_on: range_start..range_end).sum(&:value) * total_value)
    end

    it 'calculates total for dealer' do
      expect(report.calculate_total_return_amount(dealer: dealer)).to eq(report.units.where(dealer: dealer).sum(&:value) * total_value)
    end

    it 'calculates total for a dealer and date' do
      expect(report.calculate_total_return_amount(reported_on: entry.reported_on, dealer: dealer)).to eq(entry.value * total_value)
    end
  end

  describe '#dealer_share' do
    it 'calculates dealer share from total' do
      expect(report.calculate_total_dealer_share).to eq((report.calculate_total_return_amount * dealer_share_multiplier).round)
    end

    it 'calculates dealer_share for range' do
      range_start = Date.new(report.year, 1, 1)
      range_end = range_start.end_of_month
      expect(report.calculate_total_dealer_share(reported_on: range_start..range_end)).to eq((report.calculate_total_return_amount(reported_on: entry.reported_on) * dealer_share_multiplier).round)
    end

    it 'calculates total for dealer' do
      expect(report.calculate_total_dealer_share(dealer: dealer)).to eq((report.calculate_total_return_amount(dealer: dealer) * dealer_share_multiplier).round)
    end

    it 'calculates total for a dealer and date' do
      expect(report.calculate_total_dealer_share(reported_on: entry.reported_on, dealer: dealer)).to eq((entry.value * total_value * dealer_share_multiplier).round)
    end
  end
end
