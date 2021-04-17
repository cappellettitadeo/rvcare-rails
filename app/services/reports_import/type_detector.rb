module ReportsImport
  class TypeDetector
    def initialize(csv_file)
      @data = SmarterCSV.process(csv_file)
    end

    def importer
      @importer ||= begin
        # Here will be the service object selection logic
        # but for now ...
        NtpReportImporter.new(@data)
      end
    end

    private

  end
end
