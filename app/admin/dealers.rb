# frozen_string_literal: true

ActiveAdmin.register Dealer do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :company, :legal_name, :mailing_address, :city, :provice, :postal_code, :phone, :toll_free, :fax_number, :email, :location_address, :location_city, :location_province, :location_postal_code, :website, :date_joined, :shareholder, :director, :atlas_account, :dometic_account, :wells_fargo_account, :keystone_account, :td_sort_order, :sala_account, :mega_group_account, :boss_account, :dms_system, :crm_system, :employee_benefits_provider, :customs_broker, :rv_transport, :digital_marketing, :rv_brands, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:company, :legal_name, :mailing_address, :city, :provice, :postal_code, :phone, :toll_free, :fax_number, :email, :location_address, :location_city, :location_province, :location_postal_code, :website, :date_joined, :shareholder, :director, :atlas_account, :dometic_account, :wells_fargo_account, :keystone_account, :td_sort_order, :sala_account, :mega_group_account, :boss_account, :dms_system, :crm_system, :employee_benefits_provider, :customs_broker, :rv_transport, :digital_marketing, :rv_brands, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #
  permit_params do
    permitted = %i[company
                   legal_name
                   mailing_address
                   city
                   province
                   postal_code
                   phone
                   toll_free
                   fax_number
                   email
                   location_address
                   location_city
                   location_province
                   location_postal_code
                   website
                   date_joined
                   shareholder
                   director
                   atlas_account
                   dometic_account
                   wells_fargo_account
                   keystone_account
                   td_sort_order
                   sal_account
                   mega_group_account
                   boss_account
                   dms_system
                   crm_system
                   employee_benefits_provider
                   customs_broker
                   rv_transport
                   digital_marketing
                   rv_brands
                   status
                   ntp_account]
    permitted
  end

  index do
    selectable_column
    id_column
    column :company
    column :city
    column :province
    column :phone
    actions
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :company
      f.input :legal_name
      f.input :mailing_address
      f.input :city
      f.input :province
      f.input :postal_code
      f.input :phone
      f.input :toll_free
      f.input :fax_number
      f.input :email
      f.input :location_address
      f.input :location_city
      f.input :location_province
      f.input :location_postal_code
      f.input :website
      f.input :date_joined
      f.input :shareholder
      f.input :director
      f.input :atlas_account
      f.input :dometic_account
      f.input :wells_fargo_account
      f.input :keystone_account
      f.input :ntp_account
      f.input :sal_account
      f.input :mega_group_account
      f.input :boss_account
      f.input :dms_system
      f.input :crm_system
      f.input :employee_benefits_provider
      f.input :customs_broker
      f.input :rv_transport
      f.input :digital_marketing
      f.input :rv_brands
      f.input :status
    end

    f.actions
  end
end
