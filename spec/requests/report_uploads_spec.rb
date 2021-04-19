# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ReportUploads', type: :request do
  describe "POST /report_uploads" do
    let(:user) { FactoryBot.create :user }
    let(:year) { Date.today.year }
    let(:ntp_report) { FactoryBot.create(:partner_report, year: year, type: 'NtpReport') }
    let(:file) { fixture_file_upload('correct_ntp_report.csv', 'text/csv') }

    subject { post '/report_uploads', params: { report_upload: { file: file }}}

    context 'unauthorized' do
      it 'requires authentication' do
        subject
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'signed in' do
      before { sign_in user }

      context "correct way" do
        before do
          user.partner = ntp_report.partner
          FactoryBot.create :dealer, ntp_account: "110173"
          FactoryBot.create :dealer, ntp_account: "106469"
        end

        it 'responses with OK (200)' do
          subject
          expect(response.status).to eq(200)
        end

        it 'creates Sales records' do
          expect { subject }.to change(Sales, :count).from(0).to(2)
        end
      end

      context "user is not a partner" do
        it 'redirects to root url', :aggregate_failures do
          subject
          expect(response).to redirect_to(root_url)
          expect(flash[:error]).to include('no permissions for reports uploading')
        end
      end

      context "partner has no report" do
        before { user.partner = FactoryBot.create :partner }

        it 'redirects to root url', :aggregate_failures do
          subject
          expect(response).to redirect_to(root_url)
          expect(flash[:error]).to include('you need to create a partner report')
        end
      end

      context "wrong csv file" do
        let(:file) { fixture_file_upload('icon.png', 'image/png') }

        before { user.partner = ntp_report.partner }

        it 'redirects to new_upload_report page', :aggregate_failures do
          subject
          expect(response).to redirect_to(new_report_upload_url)
          expect(flash[:error]).to include('Processing csv file error')
        end
      end
    end
  end
end
