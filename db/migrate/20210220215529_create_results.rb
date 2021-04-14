# frozen_string_literal: true

class CreateResults < ActiveRecord::Migration[6.1]
  def change
    create_table :results do |t|
      t.references :dealer, null: false, foreign_key: true
      t.references :partner_report, null: false, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
