# frozen_string_literal: true

class Partner < ApplicationRecord
  has_many :partner_reports

  resourcify

  def current_report
    report_for_year(Date.today.year)
  end

  def report_for_year(year)
    partner_reports.find_by(year: year)
  end
end
