# frozen_string_literal: true

class RemoveUnitsAndRenameVolumeToQuantityForReportEntry < ActiveRecord::Migration[6.1]
  def change
    remove_column :report_entries, :units, :integer
    rename_column :report_entries, :volume, :value
  end
end
