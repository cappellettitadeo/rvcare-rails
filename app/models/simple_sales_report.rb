# frozen_string_literal: true

class SimpleSalesReport < PartnerReport
  include DealerShareMultiplierParameter

  SIMPLE_SALE_PARAMETERS_SCHEMA = Rails.root.join('config/schemas/simple_sales_parameters.json_schema').to_s

  validates :parameters, presence: true, json: { schema: SIMPLE_SALE_PARAMETERS_SCHEMA }

  def default_parameters
    {
      'sales_multiplier' => 0.01,
      'dealer_share_multiplier' => 0.6
    }
  end

  def importer(file)
    ReportsImport::SimpleSalesReportImporter.new(partner_report: self, file: file)
  end

  def example
    @@example ||= [
      'sal_account, amount, reported_on',
      'QC000158, 55, 2021-04-10',
      'QC007018, 56, 2021-04-10'
    ].freeze
  end

  private

  def calculate_return_amount(scoped_sales:, **)
    scoped_sales.sum(:value) * sales_multiplier
  end

  def sales_multiplier
    @sales_multiplier ||= parameters['sales_multiplier']
  end
end
