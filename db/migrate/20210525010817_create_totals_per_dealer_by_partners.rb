# frozen_string_literal: true

class CreateTotalsPerDealerByPartners < ActiveRecord::Migration[6.1]
  def change
    create_view :totals_per_dealer_by_partners
  end
end
