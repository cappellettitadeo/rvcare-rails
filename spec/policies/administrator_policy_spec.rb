# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdministratorPolicy, type: :policy do
  subject { described_class }

  let(:user) { User.new }
  let(:admin) { build(:user, :admin) }
  let(:scope) { Pundit.policy_scope!(user, User) }

  permissions '.scope' do
    let!(:other_user) { create(:user) }
    it 'denies by default' do
      expect(scope.to_a).to match_array([])
    end

    context 'admin' do
      let(:user) { build(:user, :admin) }

      it 'allows admin to see everyone' do
        expect(scope.to_a).to match_array([other_user])
      end
    end
  end

  permissions :index? do
    it 'index' do
      expect(subject).not_to permit(user, User.new)
      expect(subject).to permit(admin, User.new)
    end
  end

  permissions :show? do
    it 'shows' do
      expect(subject).not_to permit(user, User.new)
      expect(subject).to permit(admin, User.new)
    end
  end

  permissions :create? do
    it 'creates' do
      expect(subject).not_to permit(user, User.new)
      expect(subject).to permit(admin, User.new)
    end
  end

  permissions :update? do
    it 'updates' do
      expect(subject).not_to permit(user, User.new)
      expect(subject).to permit(admin, User.new)
    end
  end

  permissions :destroy? do
    it 'destroys' do
      expect(subject).not_to permit(user, User.new)
      expect(subject).to permit(admin, User.new)
    end
  end
end
