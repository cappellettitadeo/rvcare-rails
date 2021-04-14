# frozen_string_literal: true

class AddExtraToEntry < ActiveRecord::Migration[6.1]
  def change
    add_column :entries, :extra, :jsonb
  end
end
