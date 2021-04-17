module ReportsImport
  class NtpReportImporter
    def initialize(partner: , file:)
      @partner = partner
      @file = file
    end

    def call
      # check
      data.each do |data_item|
        store_sales_data(data_item)
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

    def store_sales_data(data_item)
      params = {
        partner_report_id: partner_report.id,
        dealer_id: data_item[:ntp_account],
        reported_on: data_item[:reported_on]
      }

      amount = data_item[:amount]
      entry = Sales.find_by(params)

      return entry.update(value: amount) if entry

      if Dealer.exists?(id: params[:dealer_id])
        Sales.create(params.merge(value: amount))
      end
    end
  end
end
