# frozen_string_literal: true

class SalCreditorReport < SalReport
  include DealerShareMultiplierParameter

  SAL_CREDITOR_PARAMETERS_SCHEMA = Rails.root.join('config/schemas/sal_creditor_parameters.json_schema').to_s

  validates :parameters, presence: true, json: { schema: SAL_CREDITOR_PARAMETERS_SCHEMA }

  def default_parameters
    {
      'contract_value' => 50,
      'endorsement_one_value' => 50,
      'endorsement_one_max_multiplier' => 0.012,
      'endorsement_one_threshold' => 13_000_000,
      'endorsement_two_value' => 55,
      'endorsement_two_max_multiplier' => 0.0125,
      'endorsement_two_threshold' => 14_000_000,
      'endorsement_three_value' => 60,
      'endorsement_three_max_multiplier' => 0.013,
      'endorsement_three_threshold' => 15_000_000,
      'endorsement_four_value' => 65,
      'endorsement_four_max_multiplier' => 0.0135,
      'dealer_share_multiplier' => 0.01,
      'new_dealer_date_cutoff' => '2019-01-01',
      'new_dealer_value' => 95,
      'new_dealer_max_multiplier' => 0.0225
    }
  end

  private

  def calculate_return_amount(scoped_units:, **)
    total_units = scoped_units.sum(:value)
    total_sales = sales.sum(:value)
    total_new_dealer_units = scoped_units.joins(:dealer).where('dealers.date_joined >= ?', new_dealer_date_cutoff).sum(:value)
    total_new_dealer_sales = sales.joins(:dealer).where('dealers.date_joined >= ?', new_dealer_date_cutoff).sum(:value)

    calculate_policy_fee(total_units: total_units) +
      calculate_endorsement_fees(total_units: total_units,
                                 total_sales: total_sales,
                                 total_new_dealer_units: total_new_dealer_units,
                                 total_new_dealer_sales: total_new_dealer_sales)
  end

  def calculate_policy_fee(total_units:)
    total_units * contract_value
  end

  def calculate_endorsement_fees(total_units:, total_sales:, total_new_dealer_units:, total_new_dealer_sales:)
    total_units_without_new_dealers = total_units - total_new_dealer_units
    total_units_without_new_dealers = [0, total_units_without_new_dealers].max
    total_sales_without_new_dealers = total_sales - total_new_dealer_sales
    total_sales_without_new_dealers = [0, total_sales_without_new_dealers].max

    fees = total_units_without_new_dealers * endorsement_fee(amount: total_sales_without_new_dealers)
    max_fees = calculate_max_fees(total_sales: total_sales_without_new_dealers).round

    new_dealer_fees = total_new_dealer_units * new_dealer_value
    new_dealer_max_fees = (total_new_dealer_sales * new_dealer_max_multiplier).round

    [fees, max_fees].min + [new_dealer_fees, new_dealer_max_fees].min
  end

  def calculate_max_fees(total_sales:)
    total_sales * endorsement_max_multiplier(amount: total_sales)
  end

  def calculate_dealer_share(scoped_sales:, **)
    scoped_sales.sum(:value) * dealer_share_multiplier
  end

  def thresholds
    @thresholds ||= (1..3).map { |n| parameters["endorsement_#{n.humanize}_threshold"] }
  end

  def endorsement_fee(amount:)
    endorsement_values(amount: amount) { endorsement_fees }
  end

  def endorsement_fees
    @endorsement_fees ||= (1..4).map { |n| parameters["endorsement_#{n.humanize}_value"] }
  end

  def endorsement_max_multiplier(amount:)
    endorsement_values(amount: amount) { endorsement_max_multipliers }
  end

  def endorsement_max_multipliers
    @endorsement_max_multipliers ||= (1..4).map { |n| parameters["endorsement_#{n.humanize}_max_multiplier"] }
  end

  def contract_value
    @contract_value ||= parameters['contract_value']
  end

  def endorsement_values(amount:)
    thresholds.each_with_index do |threshold, index|
      return yield[index] if amount <= threshold
    end

    yield.last
  end

  def new_dealer_date_cutoff
    @new_dealer_date_cutoff ||= Date.parse(parameters['new_dealer_date_cutoff'])
  end

  def new_dealer_value
    @new_dealer_value ||= parameters['new_dealer_value']
  end

  def new_dealer_max_multiplier
    @new_dealer_max_multiplier ||= parameters['new_dealer_max_multiplier']
  end
end
