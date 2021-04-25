# frozen_string_literal: true

module ReportsImport
  class WellsFargoReportImporter < BaseImporter
    def name
      'Wells Fargo Report'
    end

    private

    def dealer_id_key
      :wells_fargo_account
    end

    def perform_import_actions(params, data_item)
      store_entry(::Sales, params, data_item[:amount], data_item)
    end
  end
end
