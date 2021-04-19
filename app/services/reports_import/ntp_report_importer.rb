# frozen_string_literal: true

module ReportsImport
  class NtpReportImporter < BaseImporter
    def initialize(partner_report: , file:)
      @partner_report = partner_report
      @file = file
    end

    def call
      return if data.nil?

      data.each do |data_item|
        store_sales_data(data_item)
      end
    end

    def name
      'NTP Report'
    end

    private

    def data
      @data ||= SmarterCSV.process(@file)
    rescue StandardError => e
      register_error "Processing csv file error (#{@file.original_filename})", e
      nil
    end

    def partner_report
      @partner_report
    end

    def store_sales_data(data_item)
      unless (dealer = Dealer.find_by(ntp_account: data_item[:ntp_account]))
        add_logs(false, "error: dealer not found", data_item)
        return
      end

      params = {
        partner_report_id: partner_report.id,
        dealer_id: dealer.id,
        reported_on: data_item[:reported_on]
      }

      # Update existing entry
      if (existing_entry = Sales.find_by(params))
        if existing_entry.update(value: data_item[:amount])
          add_logs(true, 'updated', data_item)
        else
          add_logs(false, "error: #{existing_entry.errors.full_messages.to_sentence}", data_item)
        end

        return
      end

      # Create new
      new_entry = Sales.new(params.merge(value: data_item[:amount]))

      if new_entry.save
        add_logs(true, 'created', data_item)
      else
        add_logs(false, "error: #{new_entry.errors.full_messages.to_sentence}", data_item)
      end
    end
  end
end
