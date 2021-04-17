module ReportsImport
  class NtpReportImporter
    def initialize(partner: , file:)
      @partner = partner
      @file = file
    end

    def call
      data.each do |line|
        Sales.create(
          partner_report_id: partner_report.id,
          dealer_id: line[:ntp_account],
          reported_on: line[:reported_on],
          value: line[:amount]
        )
      end
    end

    def logs
      ["logs placeholder"]
    end

    private

    def data
      @data ||= SmarterCSV.process(@file)
    end

    def partner_report
      @partner_report ||= @partner.current_report
    end
  end
end
