# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PartnerReport, type: :model do
  subject(:report) { create(:partner_report, :with_sales_entries, :with_unit_entries) }

  let(:entry) { report.sales.first }

  let(:dealer) { entry.dealer }

  let(:units_entry) { report.units.first }

  let(:units_dealer) { units_entry.dealer }

  it { is_expected.to(belong_to(:partner)) }
  it { is_expected.to(have_many(:entries).dependent(:destroy)) }
  it { is_expected.to(have_many(:results).dependent(:destroy)) }
  it { is_expected.to(have_many(:dealers).through(:entries)) }
  it { is_expected.to delegate_method(:name).to(:partner).with_prefix(true).allow_nil }
  it { is_expected.to(validate_uniqueness_of(:type).scoped_to(:partner_id, :year)) }

  describe '#gross_units' do
    it 'calculates gross units' do
      expect(report.calculate_total_units).to eq(report.units.sum(&:value))
    end

    it 'calculates gross units for range' do
      range_start = Date.new(report.year, 1, 1)
      range_end = range_start.end_of_month
      expect(report.calculate_total_units(reported_on: range_start..range_end)).to eq(report.entries.where(type: 'Units', reported_on: range_start..range_end).sum(&:value))
    end

    it 'calculates total for dealer' do
      expect(report.calculate_total_units(dealer: units_dealer)).to eq(report.entries.where(type: 'Units', dealer: units_dealer).sum(&:value))
    end

    it 'calculates total for a dealer and date' do
      expect(report.calculate_total_units(reported_on: units_entry.reported_on, dealer: units_dealer)).to eq(units_entry.value)
    end
  end

  describe '#gross_sales' do
    it 'calculates gross sales' do
      expect(report.calculate_total_sales).to eq(report.sales.sum(&:value))
    end

    it 'calculates gross sales for range' do
      range_start = Date.new(report.year, 1, 1)
      range_end = range_start.end_of_month
      expect(report.calculate_total_sales(reported_on: range_start..range_end)).to eq(report.entries.where(type: 'Sales', reported_on: range_start..range_end).sum(&:value))
    end

    it 'calculates total for dealer' do
      expect(report.calculate_total_sales(dealer: dealer)).to eq(report.entries.where(type: 'Sales', dealer: dealer).sum(&:value))
    end

    it 'calculates total for a dealer and date' do
      expect(report.calculate_total_sales(reported_on: entry.reported_on, dealer: dealer)).to eq(entry.value)
    end
  end

  describe '#cache_results' do
    subject(:report) { create(:td_bank_report, :with_unit_entries) }

    before do
      report.cache_results!
      report.reload
    end

    it 'caches total results to date' do
      expect(report.calculate_total_return_amount).to eq(report.total_return_amount)
      expect(report.calculate_total_return_amount - report.calculate_total_dealer_share).to eq(report.total_rvcare_share)
      expect(report.calculate_total_dealer_share).to eq(report.total_dealer_share)
      expect(report.calculate_total_units).to eq(report.total_units)
      expect(report.calculate_total_sales).to eq(report.total_sales)
    end

    it 'caches results for dealers' do
      report.dealers.each do |dealer|
        result = report.results.where(dealer: dealer)
        expect(result.sum(:amount)).to eq(report.calculate_total_dealer_share(dealer: dealer))
        expect(result.sum(:sales)).to eq(report.sales.where(dealer: dealer).sum(:value))
        expect(result.sum(:units)).to eq(report.units.where(dealer: dealer).sum(:value))
      end
    end

    it 'does not cache twice' do
      expect {
        report.cache_results!
      }.not_to change {
        report.results.count
      }
    end
  end
end
