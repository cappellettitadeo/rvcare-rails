# frozen_string_literal: true

ActiveAdmin.register PartnerReport do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :type, :partner_id, :year, :parameters

  #
  # or
  #
  # permit_params do
  #   permitted = [:type, :partner_id, :year]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :partner_name
    column :year
    column :type
    column :calculate_total_units
    column :calculate_total_sales
    column :calculate_total_rvcare_share
    column :calculate_total_dealer_share
    actions do |report|
      year = Date.today.year
      if report.year.in? [year - 1, year]
        link_to 'Upload Reprot', new_admin_report_uploads_path(partner_id: report.partner_id, year: year),
                target: '_blank', class: 'member_link', rel: 'noopener'
      end
    end
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs do
      f.input :partner, as: :select, include_blank: false,
                        collection: options_from_collection_for_select(Partner.all, :id, :name, f.object.partner&.id)
      f.input :type, as: :select, collection: [BlankReport, TdBankReport, NtpReport, WellsFargoReport,
                                               SalWarrantyReport, SalCreditorReport, SalOtherReport]
      f.input :year
      f.input :parameters, as: :jsonb
    end
    f.actions
  end
end
