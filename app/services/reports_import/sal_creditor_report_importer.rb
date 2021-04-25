# frozen_string_literal: true

module ReportsImport
  class SalCreditorReportImporter < BaseImporter
    def name
      'Sal Creditor Report'
    end

    private

    def dealer_identification(data_item)
      { sal_account: data_item[:sal_account] }
    end

    def perform_import_actions(params, data_item)
      store_entry(::Sales, params, data_item[:amount], data_item)
      store_entry(::Units, params, data_item[:units], data_item)
    end
  end
end
