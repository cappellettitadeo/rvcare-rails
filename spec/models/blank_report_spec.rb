# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlankReport, type: :model do
  subject(:report) { create(:blank_report) }

  describe '#total' do
    it 'calculates return' do
      expect(report.calculate_total_return_amount).to eq(0)
    end
  end

  describe '#dealer_share' do
    it 'calculates dealer share' do
      expect(report.calculate_total_dealer_share).to eq(0)
    end
  end
end
