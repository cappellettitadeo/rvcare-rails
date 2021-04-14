# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Widgets', type: :request do
  let(:user) { create(:user, :admin) }
  let(:widgets) { create_list(:widget, 2) }

  shared_examples_for 'widgets' do
    describe 'GET #show' do
      context 'user has widgets' do
        before do
          user.widgets << widgets
          get widget_path(id: widgets.first.id, format: :json)
        end

        it 'responds with success' do
          expect(response).to have_http_status(:ok)
        end

        it 'responds with json content type' do
          expect(response.content_type).to start_with('application/json')
        end

        it 'renders items json keys' do
          response_body = JSON.parse(response.body)
          expect(response_body.keys).to eq(
            %w[
              widget_identifier
              html
              settings
            ]
          )
        end
      end

      context 'user does not have widgets' do
        before do
          get widget_path(id: widgets.first.id, format: :json)
        end

        it 'responds with success' do
          expect(response).to have_http_status(:ok)
        end

        it 'repsonds with json content type' do
          expect(response.content_type).to start_with('application/json')
        end

        it 'renders items json keys' do
          response_body = JSON.parse(response.body)
          expect(response_body).to eq({})
        end
      end
    end
  end

  context 'signed in' do
    before do
      sign_in(user)
    end

    it_behaves_like 'widgets'
  end
end
