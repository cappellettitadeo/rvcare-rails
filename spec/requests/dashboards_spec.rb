# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :request do
  let(:widgets) { create_list(:widget, 2) }

  context 'signed in' do
    let(:user) { create(:user, :admin) }

    before do
      sign_in user
    end

    describe 'GET #show' do
      context 'when user has widgets' do
        before do
          user.widgets << widgets
          get dashboard_path
        end

        it 'has widgets' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'PUT #update' do
      before do
        put dashboard_path, params: { dashboard: dashboard_params, format: :js }
      end

      context 'opened' do
        let(:widget) { widgets.first }
        let(:settings) do
          { 'opened' => 'true', 'x_coordinate' => '2', 'y_coordinate' => '0', 'width' => '4', 'height' => '4' }
        end
        let(:dashboard_params) { { widget.identifier => settings } }

        it 'needs to update user settings' do
          expect(user.dashboard_widget_settings(widget.identifier)).to eq(settings)
        end
      end
    end
  end
end
