# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Widget, type: :model do
  let(:widget) { create(:widget) }
  let(:user) { create(:user, :admin) }

  describe 'Associations' do
    it { is_expected.to have_and_belong_to_many(:users) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :icon }
  end

  describe 'Instance Methods' do
    describe '#indentifier' do
      it 'returns identifier for widget settings' do
        expect(widget.identifier).to eq("widget_#{widget.id}".to_sym)
      end
    end

    describe '#processed_chart_url' do
      let(:widget) { create(:widget, chart_url: 'http://something?id={{user_id}}') }
      let(:processed_chart_url) { Liquid::Template.parse(widget.chart_url).render('user_id' => user.id) }

      it 'process user id' do
        expect(widget.processed_chart_url(user)).to eq(processed_chart_url)
      end
    end
  end
end
