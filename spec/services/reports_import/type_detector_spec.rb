# frozen_string_literal: true

require 'rails_helper'

module ReportsImport
  RSpec.describe TypeDetector do
    context 'ntp reports' do
      before do
        allow(SmarterCSV).to receive(:process).and_return('fake data')
      end

      it 'returns the importer of the proper type' do
        type_detector = described_class.new('fake csv file')
        expect(type_detector.importer).to be_a_kind_of(NtpReportImporter)
      end
    end
  end
end
