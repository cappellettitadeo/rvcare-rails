# frozen_string_literal: true

class TdBankReport < PartnerReport
  include ContractValueParameter
  include DealerShareMultiplierParameter

  TD_BANK_PARAMETERS_SCHEMA = Rails.root.join('config/schemas/td_bank_parameters.json_schema').to_s

  validates :parameters, presence: true, json: { message: ->(errors) { errors }, schema: TD_BANK_PARAMETERS_SCHEMA }

  def default_parameters
    {
      'contract_value' => 51,
      'market_share_reached_extra' => 31,
      'first_look_extra' => 31,
      'dealer_share_multiplier' => 0.6
    }
  end

  def importer(file)
    ReportsImport::TdBankReportImporter.new(partner_report: self, file: file)
  end

  private

  def calculate_return_amount(scoped_units:, **)
    scoped_units.sum(:value) * average_value
  end

  def average_value
    units.map { |entry| entry_total(entry) }.sum.to_f / units.sum(:value)
  end

  def entry_total(entry)
    value = contract_value
    value += market_share_reached_extra if entry.extra&.dig('market_share_reached')
    value += first_look_extra if entry.extra&.dig('first_look')
    value * entry.value
  end

  def market_share_reached_extra
    @market_share_reached_extra ||= parameters['market_share_reached_extra']
  end

  def first_look_extra
    @first_look_extra ||= parameters['first_look_extra']
  end
end
