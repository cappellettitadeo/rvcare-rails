# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardPolicy, type: :policy do
  subject { described_class }

  let(:user) { User.new }
  let(:admin) { build(:user, :admin) }

  permissions :index? do
    it 'index' do
      expect(subject).not_to permit(user, User.new)
      expect(subject).to permit(admin, User.new)
    end
  end

  permissions :dashboard? do
    it 'shows' do
      expect(subject).not_to permit(user, User.new)
      expect(subject).to permit(admin, User.new)
    end
  end
end
