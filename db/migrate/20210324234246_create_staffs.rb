# frozen_string_literal: true

class CreateStaffs < ActiveRecord::Migration[6.1]
  def change
    create_table :staffs do |t|
      t.references :dealer, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :position
      t.string :email
      t.integer :access_id

      t.timestamps
    end
  end
end
