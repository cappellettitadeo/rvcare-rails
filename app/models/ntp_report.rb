# frozen_string_literal: true

class NtpReport < PartnerReport
  NTP_PARAMETERS_SCHEMA = Rails.root.join('config/schemas/ntp_parameters.json_schema').to_s

  validates :parameters, presence: true, json: { message: ->(errors) { errors }, schema: NTP_PARAMETERS_SCHEMA }

  def default_parameters
    {
      'first_tier_threshold_amount' => 13_500_000,
      'first_tier_multiplier' => 0.0075,
      'second_tier_multiplier' => 0.01
    }
  end

  private

  def calculate_return_amount(**)
    (calculate_first_tier_amount(amount: sales.sum(:value)) +
      calculate_second_tier_amount(amount: sales.sum(:value))).round
  end

  def dealer_share_multiplier
    0
  end

  def calculate_first_tier_amount(amount:)
    [amount, first_tier_threshold_amount].min * first_tier_multiplier
  end

  def calculate_second_tier_amount(amount:)
    second_tier_amount = amount - first_tier_threshold_amount
    return 0 if second_tier_amount.negative?

    second_tier_amount * second_tier_multiplier
  end

  def first_tier_threshold_amount
    parameters['first_tier_threshold_amount']
  end

  def first_tier_multiplier
    parameters['first_tier_multiplier']
  end

  def second_tier_multiplier
    parameters['second_tier_multiplier']
  end
end
