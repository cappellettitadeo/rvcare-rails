# frozen_string_literal: true

module ReportsImport
  class BaseImporter
    def logs
      @logs ||= []
    end

    def errors
      @errors ||= []
    end

    def errors_report
      errors.map { |e| e.values_at(:message, :exception).compact.join(": ") }.join('. ')
    end

    private

    def register_error(message, exception=nil)
      errors << { message: message, exception: exception }
    end
  end
end
