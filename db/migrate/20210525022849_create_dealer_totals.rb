# frozen_string_literal: true

class CreateDealerTotals < ActiveRecord::Migration[6.1]
  def change
    create_view :dealer_totals
  end
end
