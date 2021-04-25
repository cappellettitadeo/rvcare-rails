# frozen_string_literal: true

module ReportsImport
  class SalOtherReportImporter < BaseImporter
    def name
      'Sal Other Report'
    end

    private

    def dealer_identification(data_item)
      { sal_account: data_item[:sal_account] }
    end

    def perform_import_actions(params, data_item)
      store_entry(::Units, params, data_item[:units], data_item)
    end
  end
end
