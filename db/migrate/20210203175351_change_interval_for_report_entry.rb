# frozen_string_literal: true

class ChangeIntervalForReportEntry < ActiveRecord::Migration[6.1]
  def change
    rename_column :report_entries, :start_date, :reported_on
    remove_column :report_entries, :end_date, :date
  end
end
