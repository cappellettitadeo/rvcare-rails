# frozen_string_literal: true

class AddParametersToPartnerReport < ActiveRecord::Migration[6.1]
  def change
    add_column :partner_reports, :parameters, :jsonb
  end
end
