# frozen_string_literal: true

require 'rails_helper'

module ReportsImport
  RSpec.describe Dispatcher do
    describe '.get_importer' do
      let(:user) { FactoryBot.create(:user) }

      context 'ntp reports' do
        before do
          allow(user).to receive(:partner).and_return(instance_double('::Partner'))
        end

        it 'returns the importer of the proper type' do
          importer = described_class.get_importer(user, 'fake csv file')
          expect(importer).to be_a_kind_of(NtpReportImporter)
        end
      end
    end
  end
end
