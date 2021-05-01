# frozen_string_literal: true

class DealerReportPolicy < AdministratorPolicy
  def new?
    report_belongs_to_user?
  end

  def create?
    report_belongs_to_user?
  end

  def edit?
    report_belongs_to_user?
  end

  def update?
    report_belongs_to_user?
  end

  def destroy?
    report_belongs_to_user?
  end

  private

  def report_belongs_to_user?
    user.has_role?(:admin) || user.dealer&.id == record.dealer_id
  end
end
