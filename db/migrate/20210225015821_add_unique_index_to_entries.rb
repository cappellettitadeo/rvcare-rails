# frozen_string_literal: true

class AddUniqueIndexToEntries < ActiveRecord::Migration[6.1]
  def change
    add_index :entries, %i[dealer_id partner_report_id reported_on type],
              unique: true, name: :unique_entry
  end
end
