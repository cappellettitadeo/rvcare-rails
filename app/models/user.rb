# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_and_belongs_to_many :widgets

  has_settings do |s|
    s.key :dashboard
  end

  def admin
    has_role?(:admin)
  end

  def admin=(value)
    return add_role(:admin) if value&.to_s == 'true'

    remove_role(:admin)
  end

  def dealer
    Dealer.with_role(:dealer, self).first
  end

  def dealer?
    !dealer.nil?
  end

  def dealer=(dealer)
    dealer = Dealer.find_by(id: dealer) if dealer.is_a?(String)
    return add_role(:dealer, dealer) if dealer.present?

    remove_role(:dealer)
  end

  def partner
    Partner.with_role(:partner, self).first
  end

  def partner?
    !partner.nil?
  end

  def partner=(partner)
    partner = Partner.find_by(id: partner) if partner.is_a?(String)
    return add_role(:partner, partner) if partner.present?

    remove_role(:partner)
  end

  def dashboard_widget_settings(widget_identifier)
    settings(:dashboard).value.try(:[], widget_identifier) || Widget.default_settings
  end

  def update_dashboard!(dashboard)
    settings(:dashboard).value = dashboard
    save!
  end

  def dashboard_widget_opened?(widget_identifier)
    !settings(:dashboard).value[widget_identifier].nil?
  end
end
