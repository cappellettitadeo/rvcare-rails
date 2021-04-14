# frozen_string_literal: true

class RenameSalaAccountToSalAccountForDealer < ActiveRecord::Migration[6.1]
  def change
    rename_column :dealers, :sala_account, :sal_account
  end
end
