# frozen_string_literal: true

module ReportsImport
  class TdBankReportImporter < BaseImporter
    def name
      'Td Bank Report'
    end

    private

    def dealer_id_key
      @dealer_id_key ||=
        @partner_report.partner.custom_dealer_id&.to_sym || :sal_account
    end

    def perform_import_actions(params, data_item)
      store_entry(::Units, params, data_item[:units], data_item)
    end

    def extra(data_item)
      {
        market_share_reached: to_bool(data_item[:market_share_reached]),
        first_look: to_bool(data_item[:first_look])
      }
    end
  end
end
