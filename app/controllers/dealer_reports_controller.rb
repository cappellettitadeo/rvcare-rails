class DealerReportsController < ApplicationController
  before_action :set_dealer

  def index
    @reports = @dealer.dealer_reports.order(reported_on: :desc)
  end

  private

  def set_dealer
    @dealer = Dealer.find(params[:dealer_id])
  end
end
