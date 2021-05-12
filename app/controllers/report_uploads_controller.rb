# frozen_string_literal: true

class ReportUploadsController < ApplicationController
  before_action :set_importer, only: :create

  def new
    @report = current_user.partner&.current_report
  end

  def new_admin
    return redirect_to root_url unless is_admin?
    year = Date.today.year
    @reports = PartnerReport.includes(:partner).where(year: [year - 1, year])
    @partners_select = @reports
      .map(&:partner)
      .compact
      .map { |pr| [pr.name, pr.id] }
      .sort_by(&:first)
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
    return if (partner = get_partner).nil?

    if (report = partner.report_for_year(upload_params[:year])).nil?
      flash[:error] = "To start data import you need to have a partner report for #{upload_params[:year]} year"
      return
    end

    @importer = report.importer(upload_params[:file])
  end

  def get_partner
    if upload_params[:admin] == 'true'
      return unless is_admin?
      partner = Partner.find(upload_params[:partner_id])
    elsif (partner = current_user.partner).nil?
      flash[:error] = 'You have no permissions for reports uploading'
    end

    partner
  end

  def is_admin?
    return true if current_user.admin
    flash[:error] = 'You have no permissions for this action'
    false
  end

  def upload_params
    params.require(:report_upload)
  end
end
