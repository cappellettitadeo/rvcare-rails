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
        add_logs(data_item, "error: dealer not found")
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
          add_logs(data_item, 'updated')
        else
          add_logs(data_item, "error: #{existing_entry.errors.full_messages.to_sentence}")
        end

        return
      end

      # Create new
      new_entry = Sales.new(params.merge(value: data_item[:amount]))

      if new_entry.save
        add_logs(data_item, 'created')
      else
        add_logs(data_item, "error: #{new_entry.errors.full_messages.to_sentence}")
      end
    end

    def add_logs(data_item, message)
      logs << "#{data_item.inspect}: #{message}"
    end
  end
end
