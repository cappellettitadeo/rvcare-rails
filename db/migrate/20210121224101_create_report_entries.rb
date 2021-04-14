# frozen_string_literal: true

class CreateReportEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :report_entries do |t|
      t.string :type
      t.references :partner_report, null: false, foreign_key: true
      t.references :dealer, null: false, foreign_key: true
      t.date :date
      t.integer :units
      t.decimal :volume

      t.timestamps
    end
  end
end
