class AddCustomDealerIdToPartner < ActiveRecord::Migration[6.1]
  def change
    add_column :partners, :custom_dealer_id, :string
  end
end
