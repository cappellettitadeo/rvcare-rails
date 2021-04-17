module ReportsImport
  class Dispatcher
    class << self
      def get_importer(user, file)
        if user.partner?
          NtpReportImporter.new(partner: user.partner, file: file)
        end
      end
    end
  end
end
