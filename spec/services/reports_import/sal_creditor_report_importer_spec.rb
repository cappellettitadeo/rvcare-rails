# frozen_string_literal: true

require 'rails_helper'

module ReportsImport
  RSpec.describe SalCreditorReportImporter do
    let(:year) { Date.today.year }

    let!(:partner_report) do
      FactoryBot.create(:partner_report, year: year, type: 'SalCreditorReport')
    end

    describe '#call' do
      let(:dealer) { FactoryBot.create(:dealer, sal_account: 6.times.map { rand(10).to_s }.join) }
      let(:fake_file) { instance_double('ActionDispatch::Http::UploadedFile', original_filename: 'fake file') }

      subject { described_class.new(file: fake_file, partner_report: partner_report) }

      context 'valid input data' do
        before { allow(subject).to receive(:data).and_return(input_data) }

        let(:input_data) do
          [
            { sal_account: dealer.sal_account, amount: 10, units: 2, reported_on: "#{year}-04-10" },
            { sal_account: dealer.sal_account, amount: 17, units: 3, reported_on: "#{year}-04-11" },
          ]
        end

        it 'adds records to sales table' do
          expect { subject.call }.to change(Sales, 'count').by(input_data.size)
        end

        it 'adds records to units table' do
          expect { subject.call }.to change(Units, 'count').by(input_data.size)
        end

        it 'saves the correct data', :aggregate_failures do
          subject.call
          sales = Sales.last(2)
          units = Units.last(2)

          expect(sales.map(&:value)).to contain_exactly(10, 17)
          expect(units.map(&:value)).to contain_exactly(2, 3)

          [sales, units].each do |entries|
            expect(entries.map(&:partner_report_id)).to all(eq(partner_report.id))
            expect(entries.map(&:dealer_id)).to all(eq(dealer.id))
            expect(entries.map(&:reported_on)).to contain_exactly(Date.parse("2021-04-10"), Date.parse("2021-04-11"))
          end
        end

        context 'report is uploaded the second time' do
          let(:input_data) do
            [
              { sal_account: dealer.sal_account, amount: 10, units: 2, reported_on: "#{year}-04-10" },
              { sal_account: dealer.sal_account, amount: 17, units: 3, reported_on: "#{year}-04-11" },
            ]
          end

          before do
            allow(subject).to receive(:data).and_return(input_data)
            Entry.delete_all
            input_data.each do |item|
              Sales.create!(value: 8, partner_report_id: partner_report.id, dealer_id: dealer.id, reported_on: item[:reported_on])
              Units.create!(value: 1, partner_report_id: partner_report.id, dealer_id: dealer.id, reported_on: item[:reported_on])
            end
          end

          it "doesn't create new sales" do
            expect { subject.call }.to_not change(Sales, :count)
          end

          it "doesn't create new units" do
            expect { subject.call }.to_not change(Units, :count)
          end

          it "updates the sales' values" do
            expect { subject.call }.to \
              change { Sales.pluck(:value) }.from([8, 8]).to([10, 17])
          end

          it "updates the units' values" do
            expect { subject.call }.to \
              change { Units.pluck(:value) }.from([1, 1]).to([2, 3])
          end
        end
      end

      context 'wrong input data' do
        context 'worng file format' do
          let(:input_data) { "fake input data" }

          before do
            allow(SmarterCSV).to receive(:process).and_raise('Wrong file format')
          end

          it 'returns nil' do
            expect(subject.call).to be_nil
          end

          it 'contains the error' do
            subject.call
            expect(subject.errors).to \
              contain_exactly(a_hash_including(message: /Processing csv file error/))
          end
        end

        context 'wrong dealer_id' do
          before { allow(subject).to receive(:data).and_return(input_data) }

          let(:input_data) do
            [{ sal_account: 'unexistent ntp account', amount: 10, units: 4, reported_on: "#{year}-04-10" }]
          end

          it "doesn't create new entries" do
            Entry.delete_all
            expect { subject.call }.to_not change(Entry, 'count').from(0)
          end

          it 'records the error information to logs' do
            subject.call
            expect(subject.logs).to \
              contain_exactly(a_hash_including(success: false, message: "error: dealer not found"))
          end
        end

        context "absence of a field in data line" do
          before { Entry.delete_all }

          let(:input_data) do
            [{ sal_account: dealer.sal_account, amount: 10, units: 3, reported_on: "#{year}-04-10" }]
          end

          context 'absense of reported_on' do
            before do
              input_data.first[:reported_on] = nil
              allow(subject).to receive(:data).and_return(input_data)
            end

            it "doesn't create neither unit nor sale" do
              expect { subject.call }.to_not change(Entry, 'count').from(0)
            end

            it 'records the error information to logs' do
              subject.call
              expect(subject.logs).to \
                all(a_hash_including(success: false, message: /error: .+ can't be blank/))
            end
          end

          context 'absense of amount' do
            before do
              input_data.first[:amount] = nil
              allow(subject).to receive(:data).and_return(input_data)
            end

            it "doesn't create sales record" do
              expect { subject.call }.to_not change(Sales, 'count').from(0)
            end

            it 'creates unit record tho' do
              expect { subject.call }.to change(Units, 'count').by(1)
            end

            it 'adds error and success records to logs' do
              subject.call
              expect(subject.logs).to \
                contain_exactly(
                  a_hash_including(success: false, message: /error: .+ can't be blank/),
                  a_hash_including(success: true, message: 'created')
                )
            end
          end

          context 'absense of units' do
            before do
              input_data.first[:units] = nil
              allow(subject).to receive(:data).and_return(input_data)
            end

            it "doesn't create units record" do
              expect { subject.call }.to_not change(Units, 'count').from(0)
            end

            it 'creates sales record tho' do
              expect { subject.call }.to change(Sales, 'count').by(1)
            end

            it 'adds error and success records to logs' do
              subject.call
              expect(subject.logs).to \
                contain_exactly(
                  a_hash_including(success: false, message: /error: .+ can't be blank/),
                  a_hash_including(success: true, message: 'created')
                )
            end
          end
        end
      end
    end
  end
end
