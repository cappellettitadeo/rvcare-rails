class CreateDealerReports < ActiveRecord::Migration[6.1]
  def change
    create_table :dealer_reports do |t|
      t.references :dealer, null: false, foreign_key: true
      t.monetize :new_units_volume, currency: { present: false }
      t.integer  :new_units, default: 0
      t.monetize :used_units_volume, currency: { present: false }
      t.integer  :used_units, default: 0
      t.monetize :service_volume, currency: { present: false }
      t.monetize :parts_volume, currency: { present: false }
      t.integer  :retail_finance_contracts, default: 0
      t.monetize :creditor_volume, currency: { present: false }
      t.monetize :warranty_volume, currency: { present: false }
      t.monetize :other_volume, currency: { present: false }

      t.integer :batteries_purchases, default: 0
      t.integer :ntp_purchases, default: 0
      t.integer :dometic_purchases, default: 0
      t.integer :atlas_purchases, default: 0
      t.integer :thiebert_purchases, default: 0
      t.integer :lippert_purchases, default: 0
      t.integer :other_purchases, default: 0

      t.date :reported_on, null: false

      t.timestamps
    end
  end
end
