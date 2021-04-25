# frozen_string_literal: true

module ReportsImport
  class BaseImporter
    def initialize(partner_report: , file:)
      @partner_report = partner_report
      @file = file
    end

    def call
      return if data.nil?
      data.each { |data_item| import(data_item) }
    end

    def logs
      @logs ||= []
    end

    def errors
      @errors ||= []
    end

    def errors_report
      errors.map { |e| e.values_at(:message, :exception).compact.join(": ") }.join('. ')
    end

    def operation_stats
      total   = logs.size
      success = logs.count { |l| l[:success] }
      "Lines processed: #{total}, success: #{success}, errors: #{total - success}"
    end

    private

    def import(data_item)
      custom_id = data_item[dealer_id_key]

      unless custom_id && (dealer = Dealer.find_by(dealer_id_key => custom_id))
        add_logs(false, "error: dealer not found", data_item)
        return
      end

      params = {
        partner_report_id: partner_report.id,
        dealer_id: dealer.id,
        reported_on: data_item[:reported_on]
      }

      perform_import_actions(params, data_item)
    end

    def store_entry(entry_subclass, params, value, data_item)
      # Update existing entry
      if (existing_entry = entry_subclass.find_by(params))
        if existing_entry.update(value: value)
          add_logs(true, "#{entry_subclass} updated", data_item)
        else
          add_logs(false, "error: #{existing_entry.errors.full_messages.to_sentence}", data_item)
        end

        return
      end

      # Create new
      new_entry = entry_subclass.new(params.merge(value: value))

      if new_entry.save
        add_logs(true, "#{entry_subclass} created", data_item)
      else
        add_logs(false, "error: #{new_entry.errors.full_messages.to_sentence}", data_item)
      end
    end

    def data
      @data ||= SmarterCSV.process(@file)
    rescue StandardError => e
      register_error "Processing csv file error (#{@file.original_filename})", e
      nil
    end

    def partner_report
      @partner_report
    end

    def register_error(message, exception=nil)
      errors << { message: message, exception: exception }
    end

    def add_logs(success, message, data_item)
      logs << ({
        success: success,
        message: message,
        data_item: data_item
      })
    end
  end
end
