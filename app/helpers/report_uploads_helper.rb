# frozen_string_literal: true

module ReportUploadsHelper
  def report_data_storage(report)
    div = <<-DIV
      <div hidden='true' id='#{report.partner_id}-#{report.year}'
        data-quick-report="#{quick(report)}"
        data-example='#{report.example.join('<br>')}'>
      </div>
    DIV

    div.html_safe
  end

  def quick(report)
    verb = report.year < Date.today.year ? 'used' : 'uses'
    "The <span class='badge badge-secondary'>#{report.partner.name}</span> partner #{verb} the #{report.type} type of report in the #{report.year} year. Here you can see the example of *.csv file for this type of partner report"
  end
end
