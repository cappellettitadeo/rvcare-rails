# frozen_string_literal: true

class EastPennReport < PartnerReport
  include DealerShareMultiplierParameter
  include ThresholdMultipliers

  EAST_PENN_PARAMETERS_SCHEMA = Rails.root.join('config/schemas/east_penn_parameters.json_schema').to_s

  validates :parameters, presence: true, json: { schema: EAST_PENN_PARAMETERS_SCHEMA }

  def default_parameters
    {
      'multiplier_one' => 0.075,
      'threshold_one' => 1_500_000,
      'multiplier_two' => 0.08,
      'threshold_two' => 1_700_000,
      'multiplier_three' => 0.085,
      'dealer_share_multiplier' => 0.6
    }
  end

  private

  def calculate_return_amount(scoped_sales:, **)
    scoped_sales.sum(:value) * multiplier(amount: sales.sum(:value))
  end
end
