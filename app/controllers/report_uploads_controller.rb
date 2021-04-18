# frozen_string_literal: true

class ReportUploadsController < ApplicationController
  def new
  end

  def create
    report_file = params[:report_upload][:file]
    @importer = ReportsImport::Dispatcher.get_importer(current_user, report_file)

    unless @importer
      flash[:error] = 'You have no permissions for reports uploading'
      redirect_to root_url
    end

    if @importer.call
      render 'operation_logs'
    else
      flash[:error] = @importer.errors_report
      redirect_to new_report_upload_url
    end
  end
end
