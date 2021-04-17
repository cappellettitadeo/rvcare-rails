# frozen_string_literal: true

class ReportUploadsController < ApplicationController
  def new
  end

  def create
    report_file = params[:report_upload][:file]
    @importer = ReportsImport::Dispatcher.get_importer(current_user, report_file)
    @importer.call
    render 'operation_logs'
  end
end
