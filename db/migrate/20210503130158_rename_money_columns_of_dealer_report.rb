# frozen_string_literal: true

class RenameMoneyColumnsOfDealerReport < ActiveRecord::Migration[6.1]
  def change
    rename_column :dealer_reports, :new_units_volume_cents, :new_units_volume
    rename_column :dealer_reports, :used_units_volume_cents, :used_units_volume
    rename_column :dealer_reports, :service_volume_cents, :service_volume
    rename_column :dealer_reports, :parts_volume_cents, :parts_volume
    rename_column :dealer_reports, :creditor_volume_cents, :creditor_volume
    rename_column :dealer_reports, :warranty_volume_cents, :warranty_volume
    rename_column :dealer_reports, :other_volume_cents, :other_volume
  end
end
