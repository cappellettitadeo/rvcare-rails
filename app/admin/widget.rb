# frozen_string_literal: true

ActiveAdmin.register Widget do
  permit_params :name, :icon, :chart_url

  index do
    selectable_column
    id_column
    column :name
    column :chart_url
    column :icon
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :chart_url
      row :icon
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :name
      f.input :icon
      f.input :chart_url
    end

    f.actions
  end
end
