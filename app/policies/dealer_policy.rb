# frozen_string_literal: true

class DealerPolicy < AdministratorPolicy
  def show?
    user.has_role?(:admin) || user.dealer == record
  end
end
