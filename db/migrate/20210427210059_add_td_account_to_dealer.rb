class AddTdAccountToDealer < ActiveRecord::Migration[6.1]
  def change
    add_column :dealers, :td_account, :string
  end
end
