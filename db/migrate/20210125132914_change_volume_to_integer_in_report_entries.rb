# frozen_string_literal: true

class ChangeVolumeToIntegerInReportEntries < ActiveRecord::Migration[6.1]
  def change
    change_column :report_entries, :volume, :integer, default: 0
    change_column_default :report_entries, :units, 0
  end
end
