# frozen_string_literal: true

module ReportsImport
  class SalCreditorReportImporter < BaseImporter
    def name
      'Sal Creditor Report'
    end

    private

    def import(data_item)
      unless (dealer = Dealer.find_by(sal_account: data_item[:sal_account]))
        add_logs(false, "error: dealer not found", data_item)
        return
      end

      params = {
        partner_report_id: partner_report.id,
        dealer_id: dealer.id,
        reported_on: data_item[:reported_on]
      }

      store_entry(::Sales, params, data_item[:amount], data_item)
      store_entry(::Units, params, data_item[:units], data_item)
    end

    def store_entry(entry_subclass, params, value, data_item)
      # Update existing entry
      if (existing_entry = entry_subclass.find_by(params))
        if existing_entry.update(value: value)
          add_logs(true, 'updated', data_item)
        else
          add_logs(false, "error: #{existing_entry.errors.full_messages.to_sentence}", data_item)
        end

        return
      end

      # Create new
      new_entry = entry_subclass.new(params.merge(value: value))

      if new_entry.save
        add_logs(true, 'created', data_item)
      else
        add_logs(false, "error: #{new_entry.errors.full_messages.to_sentence}", data_item)
      end
    end
  end
end
