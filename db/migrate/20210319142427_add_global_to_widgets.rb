# frozen_string_literal: true

class AddGlobalToWidgets < ActiveRecord::Migration[6.1]
  def change
    add_column :widgets, :global, :boolean, default: false
  end
end
