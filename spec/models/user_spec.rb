# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  let(:widget) { create(:widget) }
  let(:widget_saved_settings) do
    user.settings(:dashboard).value[widget.identifier] = { opened: true, width: 8, height: 9, x_coordinate: 43, y_coordinate: 45 }
    user.save!
  end

  describe '#admin' do
    it 'is not admin' do
      expect(user.admin).to be_falsey
    end

    it 'makes admin' do
      user.admin = true
      expect(user.admin).to be_truthy
    end

    it 'makes admin with string' do
      user.admin = 'true'
      expect(user.admin).to be_truthy
    end

    context 'is admin' do
      subject(:user) { create(:user, :admin) }

      it 'is admin' do
        expect(user.admin).to be_truthy
      end

      it 'removes admin' do
        user.admin = false
        expect(user).not_to have_role(:admin)
      end
    end
  end

  describe '#dealer' do
    let(:dealer) { create(:dealer) }

    it 'has no dealer' do
      expect(user.dealer).to be_nil
      expect(user).not_to have_role(:dealer, dealer)
    end

    it 'is a dealer' do
      expect(user).not_to be_dealer
    end

    it 'sets dealer' do
      user.dealer = dealer
      expect(user).to have_role(:dealer, dealer)
      expect(user.dealer).to eq dealer
    end

    it 'sets dealer with a string' do
      user.dealer = dealer.id.to_s
      expect(user).to have_role(:dealer, dealer)
      expect(user.dealer).to eq dealer
    end

    context 'with dealer' do
      before do
        user.dealer = dealer
      end

      it 'is a dealer' do
        expect(user).to be_dealer
      end

      it 'unsets dealer' do
        user.dealer = nil
        expect(Dealer.with_role(:dealer, user)).to be_empty
        expect(user.dealer).to eq nil
      end

      it 'unsets dealer with empty string' do
        user.dealer = ''
        expect(Dealer.with_role(:dealer, user)).to be_empty
        expect(user.dealer).to eq nil
      end
    end
  end

  describe '#partner' do
    let(:partner) { create(:partner) }

    it 'has no partner' do
      expect(user.partner).to be_nil
      expect(user).not_to have_role(:partner, partner)
    end

    it 'is a partner' do
      expect(user).not_to be_partner
    end

    it 'sets partner' do
      user.partner = partner
      expect(user).to have_role(:partner, partner)
      expect(user.partner).to eq partner
    end

    it 'sets partner from a string' do
      user.partner = partner.id.to_s
      expect(user).to have_role(:partner, partner)
      expect(user.partner).to eq partner
    end

    context 'with partner' do
      before do
        user.partner = partner
      end

      it 'is a partner' do
        expect(user).to be_partner
      end

      it 'unsets partner' do
        user.partner = nil
        expect(Partner.with_role(:partner, user)).to be_empty
        expect(user.partner).to eq nil
      end

      it 'unsets with empty string' do
        user.partner = ''
        expect(Partner.with_role(:partner, user)).to be_empty
        expect(user.partner).to eq nil
      end
    end
  end

  describe '#dashboard_widget_settings' do
    context 'widget settings present' do
      it 'returns settings for particular widget' do
        widget_saved_settings
        expect(user.dashboard_widget_settings(widget.identifier)).to eq(user.settings(:dashboard).value[widget.identifier])
      end
    end

    context 'widget settings not present' do
      it 'returns default settings' do
        expect(user.dashboard_widget_settings(widget.identifier)).to eq(Widget.default_settings)
      end
    end
  end

  describe '#update_dashboard' do
    it 'save entire dashboards' do
      user.update_dashboard!(
        'widget_1' => { 'width' => 1, 'height' => 2, 'x_coordinate' => 3, 'y_coordinate' => 4 },
        'widget_2' => { 'width' => 5, 'height' => 6, 'x_coordinate' => 7, 'y_coordinate' => 8 }
      )
      expect(user.settings(:dashboard).value['widget_1']['width']).to eq 1
      expect(user.settings(:dashboard).value['widget_1']['height']).to eq 2
      expect(user.settings(:dashboard).value['widget_1']['x_coordinate']).to eq 3
      expect(user.settings(:dashboard).value['widget_1']['y_coordinate']).to eq 4

      expect(user.settings(:dashboard).value['widget_2']['width']).to eq 5
      expect(user.settings(:dashboard).value['widget_2']['height']).to eq 6
      expect(user.settings(:dashboard).value['widget_2']['x_coordinate']).to eq 7
      expect(user.settings(:dashboard).value['widget_2']['y_coordinate']).to eq 8
    end
  end

  describe '#dashboard_widget_opened?' do
    context 'widget setting is present' do
      it 'returns opened value' do
        widget_saved_settings
        expect(user.dashboard_widget_opened?(widget.identifier)).to eq(true)
      end
    end
  end
end
