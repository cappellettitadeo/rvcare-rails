# frozen_string_literal: true

class ChangeDateRangesInReportEntry < ActiveRecord::Migration[6.1]
  def change
    rename_column :report_entries, :date, :start_date
    add_column :report_entries, :end_date, :date
  end
end
