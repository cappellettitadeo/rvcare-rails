# frozen_string_literal: true

ActiveAdmin.register Partner do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name

  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    selectable_column
    id_column
    column :name
    actions do |partner|
      if partner.current_report
        link_to 'Upload Reprot', new_admin_report_uploads_path(partner_id: partner.id),
          target: '_blank', class: 'member_link'
      end
    end
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
