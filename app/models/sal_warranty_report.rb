# frozen_string_literal: true

class SalWarrantyReport < SalReport
  SAL_WARRANTY_PARAMETERS_SCHEMA = Rails.root.join('config/schemas/sal_warranty_parameters.json_schema').to_s

  validates :parameters, presence: true, json: { schema: SAL_WARRANTY_PARAMETERS_SCHEMA }

  def default_parameters
    {
      'contract_value' => 27,
      'bonus_value' => 25,
      'dealer_share_value' => 25,
      'new_dealer_value' => 37,
      'new_dealer_date_cutoff' => '2019-01-01'
    }
  end

  private

  def calculate_return_amount(scoped_units:, **)
    sum_of_new_user_units = sum_of_new_user_units(scoped_units: scoped_units)

    (scoped_units.sum(:value) - sum_of_new_user_units) * (contract_value + bonus_value) +
      (sum_of_new_user_units * (new_dealer_value + bonus_value))
  end

  def sum_of_new_user_units(scoped_units:)
    scoped_units.joins(:dealer)
                .where('dealers.date_joined >= ?', new_dealer_date_cutoff)
                .where("reported_on < date (dealers.date_joined + interval '12 months')")
                .sum(:value)
  end

  def calculate_dealer_share(scoped_units:, **)
    scoped_units.sum(:value) * dealer_share_value
  end

  def contract_value
    @contract_value ||= parameters['contract_value']
  end

  def bonus_value
    @bonus_value ||= parameters['bonus_value']
  end

  def new_dealer_value
    @new_dealer_value ||= parameters['new_dealer_value']
  end

  def new_dealer_date_cutoff
    @new_dealer_date_cutoff ||= parameters['new_dealer_date_cutoff']
  end

  def dealer_share_value
    @dealer_share_value ||= parameters['dealer_share_value']
  end
end
