# frozen_string_literal: true

class ReportUploadsController < ApplicationController
  def new
  end

  def create
    report_file = params[:report_upload][:file]
    importer = ReportsImport::TypeDetector.new(report_file).importer
    importer.call
    @logs = importer.logs

    render 'operation_logs'
  end

end
