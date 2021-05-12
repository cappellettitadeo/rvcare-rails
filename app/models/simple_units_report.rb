# frozen_string_literal: true

class SimpleUnitsReport < PartnerReport
  include ContractValueParameter
  include DealerShareMultiplierParameter

  SIMPLE_UNITS_PARAMETERS_SCHEMA = Rails.root.join('config/schemas/simple_units_parameters.json_schema').to_s

  validates :parameters, presence: true, json: { schema: SIMPLE_UNITS_PARAMETERS_SCHEMA }

  def default_parameters
    {
      'contract_value' => 2,
      'dealer_share_multiplier' => 0.6
    }
  end

  def importer(file)
    ReportsImport::SimpleUnitsReportImporter.new(partner_report: self, file: file)
  end

  def example
    @@example ||= [
      'sal_account, units, reported_on',
      'QC000158, 55, 2021-04-10',
      'QC007018, 56, 2021-04-10'
    ].freeze
  end

  private

  def calculate_return_amount(scoped_units:, **)
    scoped_units.sum(:value) * contract_value
  end
end
