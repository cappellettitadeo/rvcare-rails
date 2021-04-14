# frozen_string_literal: true

class SetDefaultForParamteresOfPartnerReport < ActiveRecord::Migration[6.1]
  def change
    change_column_default :partner_reports, :parameters, {}
  end
end
