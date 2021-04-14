# frozen_string_literal: true

class AddCachedTotalsToPartnerReport < ActiveRecord::Migration[6.1]
  def change
    change_table :partner_reports, bulk: true do |t|
      t.integer :cached_rvcare_share, default: 0
      t.integer :cached_dealer_share, default: 0
    end

    change_column_default :partner_reports, :type, from: nil, to: 'BlankReport'

    # rubocop:disable Rails/SkipsModelValidations
    PartnerReport.where(type: nil).update_all(type: 'BlankReport')
    # rubocop:enable Rails/SkipsModelValidations
  end
end
