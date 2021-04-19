# frozen_string_literal: true

class ReportUploadsController < ApplicationController
  before_action :set_importer, only: :create

  def new
  end

  def create
    return redirect_to(root_url) unless @importer

    if @importer.call
      render 'operation_logs'
    else
      flash[:error] = @importer.errors_report
      redirect_to new_report_upload_url
    end
  end

  private

  def set_importer
    if (partner = current_user.partner).nil?
      flash[:error] = 'You have no permissions for reports uploading'
      return
    end

    if (report = partner.current_report).nil?
      flash[:error] = "To start data import you need to create a partner report for #{Date.today.year} year"
      return
    end

    @importer = report.importer(params[:report_upload][:file])
  end
end
