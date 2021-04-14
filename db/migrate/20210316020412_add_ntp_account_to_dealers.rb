# frozen_string_literal: true

class AddNtpAccountToDealers < ActiveRecord::Migration[6.1]
  def change
    add_column :dealers, :ntp_account, :string
  end
end
