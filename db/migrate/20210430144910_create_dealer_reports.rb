class CreateDealerReports < ActiveRecord::Migration[6.1]
  def change
    create_table :dealer_reports do |t|
      t.references :dealer, null: false, foreign_key: true
      t.monetize :new_units_volume, currency: { present: false }
      t.integer  :new_units
      t.monetize :used_units_volume, currency: { present: false }
      t.integer  :used_units
      t.monetize :service_volume, currency: { present: false }
      t.monetize :parts_volume, currency: { present: false }
      t.integer  :retail_finance_contracts
      t.monetize :creditor_volume, currency: { present: false }
      t.monetize :warranty_volume, currency: { present: false }
      t.monetize :other_volume, currency: { present: false }

      t.integer :batteries_purchases
      t.integer :ntp_purchases
      t.integer :dometic_purchases
      t.integer :atlas_purchases
      t.integer :thiebert_purchases
      t.integer :lippert_purchases
      t.integer :other_purchases

      t.timestamps
    end
  end
end
