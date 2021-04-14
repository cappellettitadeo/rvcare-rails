# frozen_string_literal: true

class CacheTotalReturnAmount < ActiveRecord::Migration[6.1]
  def change
    add_column :partner_reports, :total_return_amount, :integer, default: 0
  end
end
