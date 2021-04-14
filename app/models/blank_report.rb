# frozen_string_literal: true

class BlankReport < PartnerReport
  private

  def calculate_return_amount(*)
    0
  end

  def calculate_dealer_share(*)
    0
  end
end
