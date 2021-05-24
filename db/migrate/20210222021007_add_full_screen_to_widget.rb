# frozen_string_literal: true

class AddFullScreenToWidget < ActiveRecord::Migration[6.1]
  def change
    add_column :widgets, :fullscreen, :boolean, default: false
  end
end
