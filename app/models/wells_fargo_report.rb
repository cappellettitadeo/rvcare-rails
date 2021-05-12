# frozen_string_literal: true

class WellsFargoReport < PartnerReport
  include ThresholdMultipliers
  include DealerShareMultiplierParameter

  WELLS_FARGO_PARAMETERS_SCHEMA = Rails.root.join('config/schemas/wells_fargo_parameters.json_schema').to_s

  validates :parameters, presence: true, json: { message: ->(errors) { errors }, schema: WELLS_FARGO_PARAMETERS_SCHEMA }

  def default_parameters
    {
      'multiplier_one' => 0.0,
      'threshold_one' => 155_000_000,
      'multiplier_two' => 0.0002,
      'threshold_two' => 180_000_000,
      'multiplier_three' => 0.0003,
      'threshold_three' => 205_000_000,
      'multiplier_four' => 0.0004,
      'threshold_four' => 230_000_000,
      'multiplier_five' => 0.0005,
      'threshold_five' => 305_000_000,
      'multiplier_six' => 0.0006,
      'dealer_share_multiplier' => 0.6
    }
  end

  def importer(file)
    ReportsImport::WellsFargoReportImporter.new(partner_report: self, file: file)
  end

  def example
    @@example ||= [
      'wells_fargo_account, amount, reported_on',
      '102971, 55, 2021-04-10',
      '199818, 56, 2021-04-10',
      '212676, 100, 2021-04-10',
      '102971, 1, 2021-04-12'
    ].freeze
  end

  private

  def calculate_return_amount(scoped_sales:, **)
    scoped_sales.sum(:value) * multiplier(amount: sales.sum(:value))
  end
end
