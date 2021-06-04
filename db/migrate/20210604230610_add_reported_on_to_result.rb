# frozen_string_literal: true

class AddReportedOnToResult < ActiveRecord::Migration[6.1]
  def change
    add_column :results, :reported_on, :date, null: false
    add_index :results, %i[partner_report_id dealer_id reported_on], unique: true, name: 'results_main_index'
  end
end
