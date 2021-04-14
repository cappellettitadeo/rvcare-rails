# frozen_string_literal: true

class RenameReportEntryToEntry < ActiveRecord::Migration[6.1]
  def change
    rename_table :report_entries, :entries
  end
end
