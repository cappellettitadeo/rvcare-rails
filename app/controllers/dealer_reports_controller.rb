class DealerReportsController < ApplicationController
  before_action :set_dealer
  before_action :set_report, only: [:edit, :update, :destroy]

  def index
    authorize @dealer, :show?
    @reports = @dealer.dealer_reports.order(reported_on: :desc)
  end

  def new
    @report = @dealer.dealer_reports.new(reported_on: Date.today)
    authorize @report
  end

  def create
    @report = @dealer.dealer_reports.build(report_params)
    authorize @report

    if @report.save
      flash[:success] = "Report successfully created"
      redirect_to dealer_reports_url(@dealer)
    else
      render :new
    end
  end

  def edit
    authorize @report
  end

  def update
    authorize @report

    if @report.update(report_params)
      flash[:success] = "Report successfully updated"
      redirect_to dealer_reports_url(@dealer)
    else
      render :edit
    end
  end

  def destroy
    authorize @report

    @report.destroy!
    flash[:success] = "Report successfully deleted"
    redirect_to dealer_reports_url(@dealer)
  end

  private

  def set_dealer
    @dealer = Dealer.find(params[:dealer_id])
  end

  def set_report
    @report = DealerReport.find(params[:id])
  end

  def report_params
    params.require(:dealer_report).permit(
      :new_units_volume, :new_units, :used_units_volume, :used_units, :service_volume,
      :parts_volume, :retail_finance_contracts, :creditor_volume, :warranty_volume,
      :other_volume, :batteries_purchases, :ntp_purchases, :dometic_purchases,
      :atlas_purchases, :thiebert_purchases, :lippert_purchases, :other_purchases,
      :reported_on
    )
  end
end
