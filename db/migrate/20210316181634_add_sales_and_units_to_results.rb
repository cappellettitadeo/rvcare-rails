# frozen_string_literal: true

class AddSalesAndUnitsToResults < ActiveRecord::Migration[6.1]
  def change
    add_column :results, :sales, :integer, default: 0
    add_column :results, :units, :integer, default: 0
  end
end
