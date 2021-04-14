# frozen_string_literal: true

module ActiveAdmin
  class PagePolicy < AdministratorPolicy
    class Scope < Scope
      def resolve
        scope.all
      end
    end

    def index?
      user.has_role?(:admin)
    end

    def show?
      user.has_role?(:admin)
    end

    def create?
      user.has_role?(:admin)
    end

    def new?
      create?
    end

    def update?
      user.has_role?(:admin)
    end

    def edit?
      update?
    end

    def destroy?
      user.has_role?(:admin)
    end
  end
end
