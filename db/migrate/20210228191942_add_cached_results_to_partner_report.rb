# frozen_string_literal: true

class AddCachedResultsToPartnerReport < ActiveRecord::Migration[6.1]
  def change
    rename_column :partner_reports, :cached_dealer_share, :total_dealer_share
    rename_column :partner_reports, :cached_rvcare_share, :total_rvcare_share
    add_column :partner_reports, :total_units, :integer
    add_column :partner_reports, :total_sales, :integer
  end
end
