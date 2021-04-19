# frozen_string_literal: true

require 'rails_helper'

module ReportsImport
  RSpec.describe NtpReportImporter do
    let(:year) { Date.today.year }

    context 'ntp reports' do
      let!(:partner_report) do
        FactoryBot.create(:partner_report, year: year, type: 'NtpReport')
      end

      describe '#call' do
        let(:dealer) { FactoryBot.create(:dealer, ntp_account: 6.times.map { rand(10).to_s }.join) }

        subject { NtpReportImporter.new(file: 'fake file', partner: partner_report.partner) }

        before do
          allow(subject).to receive(:data).and_return(input_data)
        end

        context 'valid input data' do
          let(:input_data) do
            [
              { ntp_account: dealer.ntp_account, amount: 10, reported_on: "#{year}-04-10" },
              { ntp_account: dealer.ntp_account, amount: 17, reported_on: "#{year}-04-11" },
            ]
          end

          it 'adds records to entries table' do
            expect { subject.call }.to change(Entry, 'count').by(input_data.size)
          end

          it 'saves the correct data', :aggregate_failures do
            subject.call
            entries = Entry.last(2)

            expect(entries.map(&:type)).to all(eq("Sales"))
            expect(entries.map(&:partner_report_id)).to all(eq(partner_report.id))
            expect(entries.map(&:dealer_id)).to all(eq(dealer.id))
            expect(entries.map(&:reported_on)).to contain_exactly(Date.parse("2021-04-10"), Date.parse("2021-04-11"))
            expect(entries.map(&:value)).to contain_exactly(10, 17)
          end
        end

        context 'wrong dealer_id' do
          let(:input_data) do
            [
              { ntp_account: 'unexistent ntp account', amount: 10, reported_on: "#{year}-04-10" }
            ]
          end

          it "doesn't create new entry" do
            Entry.delete_all
            expect { subject.call }.to_not change(Entry, 'count').from(0)
          end
        end
      end

      it 'returns operation logs'
    end
  end
end
