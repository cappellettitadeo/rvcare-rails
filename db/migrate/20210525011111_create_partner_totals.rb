# frozen_string_literal: true

class CreatePartnerTotals < ActiveRecord::Migration[6.1]
  def change
    create_view :partner_totals
  end
end
