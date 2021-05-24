# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FullscreenDashboardController, type: :controller do
  let(:user) { create(:user, :admin, :with_fullscreen_dashboard_widget) }
  let(:widget) { user.widgets.first }

  describe 'GET /show' do
    before do
      sign_in(user)
    end

    context 'with widgets' do
      it 'returns widgets without category' do
        get :show

        expect(response).to have_http_status(:success)

        expect(assigns(:fullscreen_widgets)).to contain_exactly(widget)
      end

      context 'with global' do
        let!(:global_widget) { create(:widget, :fullscreen, :global, category_list: ['dashboard']) }

        it 'global and personal widgets' do
          get :show

          expect(response).to have_http_status(:success)

          expect(assigns(:fullscreen_widgets)).to contain_exactly(global_widget, widget)
        end
      end

      context 'with widget category filter' do
        let(:category_widget) { create(:widget, :fullscreen, category_list: ['chicken']) }

        before do
          user.widgets << category_widget
        end

        it 'returns only widgets with category' do
          get :show, params: { categories: 'chicken' }

          expect(response).to have_http_status(:success)

          expect(assigns(:fullscreen_widgets)).to contain_exactly(category_widget)
        end

        context 'with global' do
          let!(:hidden_widget) { create(:widget, :fullscreen, :global, category_list: ['not_chicken']) }
          let!(:global_widget) { create(:widget, :fullscreen, :global, category_list: ['chicken']) }

          it 'global and personal widgets' do
            get :show, params: { categories: 'chicken' }

            expect(response).to have_http_status(:success)

            expect(assigns(:fullscreen_widgets)).to contain_exactly(global_widget, category_widget)
          end

          context 'duplicate' do
            let(:global_user_widget) { create(:widget, :fullscreen, :global, category_list: ['chicken']) }

            before do
              user.widgets << global_user_widget
            end

            it 'global and personal widgets' do
              get :show, params: { categories: 'chicken' }

              expect(response).to have_http_status(:success)

              expect(assigns(:fullscreen_widgets)).to contain_exactly(global_widget, global_user_widget, category_widget)
            end
          end
        end
      end
    end
  end
end
