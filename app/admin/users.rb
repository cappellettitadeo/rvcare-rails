# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :first_name,
                :last_name,
                :email,
                :password,
                :password_confirmation,
                :admin,
                :dealer,
                :partner,
                widget_ids: []

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end

    f.inputs 'Roles' do
      f.input :admin, as: :boolean, unchecked_value: 'false', checked_value: 'true',
                      input_html: { data: { if: 'checked', then: 'hide', target: '.resources' } }
      f.input :partner?, as: :boolean, label: 'Partner',
                         input_html: { data: { if: 'not_checked', then: 'hide', target: '.resource_partner' } }
      f.input :partner, as: :select, include_blank: false,
                        collection: options_from_collection_for_select(Partner.all, :id, :name, f.object.partner&.id),
                        wrapper_html: { class: 'resources resource_partner' }
      f.input :dealer?, as: :boolean, label: 'Dealer',
                        input_html: { data: { if: 'not_checked', then: 'hide', target: '.resource_dealer' } }
      f.input :dealer, as: :select, include_blank: false,
                       collection: options_from_collection_for_select(Dealer.all, :id, :company, f.object.dealer&.id),
                       wrapper_html: { class: 'resources resource_dealer' }
    end

    f.inputs 'Widgets' do
      f.input :widgets, as: :select
    end

    f.actions
  end

  before_action :remove_password_params_if_blank, only: [:update]
  before_action :remove_virtual_fields, only: [:update]

  controller do
    def remove_password_params_if_blank
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
    end

    def remove_virtual_fields
      params[:user][:partner] = '' if params[:user][:partner?] != '1'
      params[:user][:dealer] = '' if params[:user][:dealer?] != '1'
      params[:user].delete(:partner?)
      params[:user].delete(:dealer?)
    end
  end
end
