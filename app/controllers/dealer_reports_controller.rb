class DealerReportsController < ApplicationController
  before_action :set_dealer, only: [:index, :new, :create]
  before_action :set_report, only: [:edit, :update]

  def index
    @reports = @dealer.dealer_reports.order(reported_on: :desc)
  end

  def new
    @report = @dealer.dealer_reports.new
  end

  def create
    @report = @dealer.dealer_reports.build(report_params)

    if @report.save
      flash[:success] = "New report created"
      redirect_to dealer_reports_url
    else
      render :new
    end
  end

  def edit
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
