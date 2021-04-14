# frozen_string_literal: true

class SalOtherReport < SalReport
  include DealerShareMultiplierParameter

  SAL_OTHER_PARAMETERS_SCHEMA = Rails.root.join('config/schemas/sal_other_parameters.json_schema').to_s

  validates :parameters, presence: true, json: { schema: SAL_OTHER_PARAMETERS_SCHEMA }

  def default_parameters
    {
      'contract_value' => 2,
      'dealer_share_multiplier' => 0.6
    }
  end

  private

  def calculate_return_amount(scoped_units:, **)
    scoped_units.sum(:value) * contract_value
  end

  def contract_value
    @contract_value ||= parameters['contract_value']
  end
end
