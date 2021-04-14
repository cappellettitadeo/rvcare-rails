# frozen_string_literal: true

class AddUniqueIndexToPartnerReports < ActiveRecord::Migration[6.1]
  def change
    add_index :partner_reports, %i[partner_id year type],
              unique: true, name: :unique_partner_report
  end
end
