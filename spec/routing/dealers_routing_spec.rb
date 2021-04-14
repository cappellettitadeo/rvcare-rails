# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DealersController, type: :routing do
  describe 'routing' do
    it 'routes to #edit' do
      expect(get: '/dealers/1/edit').to route_to('dealers#edit', id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/dealers/1').to route_to('dealers#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/dealers/1').to route_to('dealers#update', id: '1')
    end
  end
end
