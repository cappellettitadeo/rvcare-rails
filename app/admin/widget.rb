# frozen_string_literal: true

ActiveAdmin.register Widget do
  permit_params :name, :icon, :chart_url, :fullscreen, :category_list, :global

  index do
    selectable_column
    id_column
    column :name
    column :chart_url
    column :icon
    column :fullscreen
    column :created_at
    column :updated_at
    column :category_list
    column :global
    actions
  end

  show do
    attributes_table do
      row :name
      row :chart_url
      row :icon
      row :fullscreen
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
      f.input :fullscreen
      f.input :global
      f.input :category_list
    end

    f.actions
  end
end
