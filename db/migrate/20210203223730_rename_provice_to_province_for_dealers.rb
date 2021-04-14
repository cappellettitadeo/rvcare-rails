# frozen_string_literal: true

class RenameProviceToProvinceForDealers < ActiveRecord::Migration[6.1]
  def change
    rename_column :dealers, :provice, :province
  end
end
