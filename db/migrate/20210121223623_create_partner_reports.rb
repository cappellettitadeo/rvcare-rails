# frozen_string_literal: true

class CreatePartnerReports < ActiveRecord::Migration[6.1]
  def change
    create_table :partner_reports do |t|
      t.string :type
      t.references :partner, null: false, foreign_key: true
      t.integer :year

      t.timestamps
    end
  end
end
