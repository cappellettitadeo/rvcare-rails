# frozen_string_literal: true

class CreateDealers < ActiveRecord::Migration[6.1]
  def change
    create_table :dealers do |t|
      t.string :company
      t.string :legal_name
      t.string :mailing_address
      t.string :city
      t.string :provice
      t.string :postal_code
      t.string :phone
      t.string :toll_free
      t.string :fax_number
      t.string :email
      t.string :location_address
      t.string :location_city
      t.string :location_province
      t.string :location_postal_code
      t.string :website
      t.date :date_joined
      t.boolean :shareholder
      t.boolean :director
      t.string :atlas_account
      t.integer :dometic_account
      t.integer :wells_fargo_account
      t.integer :keystone_account
      t.string :td_sort_order
      t.string :sala_account
      t.integer :mega_group_account
      t.integer :boss_account
      t.string :dms_system
      t.string :crm_system
      t.string :employee_benefits_provider
      t.string :customs_broker
      t.string :rv_transport
      t.string :digital_marketing
      t.text :rv_brands
      t.string :status

      t.timestamps
    end
  end
end
