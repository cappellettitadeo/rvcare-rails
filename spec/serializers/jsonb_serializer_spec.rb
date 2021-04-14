# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JsonbSerializer, type: :serializer do
  describe '#dump' do
    it 'returns string from hash' do
      expect(described_class.dump({ a: 'a' })).to eq({ a: 'a' }.to_json)
    end

    it 'returns string from string' do
      expect(described_class.dump({ a: 'a' }.to_json)).to eq({ a: 'a' }.to_json)
    end

    it 'returns nil from empty string' do
      expect(described_class.dump('')).to be_nil
    end
  end

  describe '#load' do
    it 'returns hash from string' do
      expect(described_class.load({ a: 'a' }.to_json)).to eq({ 'a' => 'a' })
    end

    it 'returns hash from hash' do
      expect(described_class.load({ a: 'a' })).to eq({ a: 'a' })
    end

    it 'returns nil from empty string' do
      expect(described_class.load('')).to be_nil
    end

    it 'returns nil from nil' do
      expect(described_class.load(nil)).to be_nil
    end
  end
end
