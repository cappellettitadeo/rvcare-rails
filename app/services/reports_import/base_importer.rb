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
