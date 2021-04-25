# frozen_string_literal: true

module ReportsImport
  class SimpleUnitsReportImporter < BaseImporter
    def name
      'Simple Units Report'
    end

    def dealer_id_key
      @dealer_id_key ||=
        @partner_report.partner.custom_dealer_id&.to_sym || :sal_account
    end

    private

    def perform_import_actions(params, data_item)
      store_entry(::Units, params, data_item[:units], data_item)
    end
  end
end
