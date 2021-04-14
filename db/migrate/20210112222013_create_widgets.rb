# frozen_string_literal: true

class CreateWidgets < ActiveRecord::Migration[6.1]
  def change
    create_table :widgets do |t|
      t.string :name
      t.string :icon
      t.string :chart_url

      t.timestamps
    end
    create_join_table :users, :widgets do |t|
      t.index %i[user_id widget_id]
    end
  end
end
