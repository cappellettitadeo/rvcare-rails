# frozen_string_literal: true

class Widget < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, presence: true
  validates :icon, presence: true

  def self.default_settings
    {
      width: 6,
      height: 5,
      x_coordinate: 0,
      y_coordinate: 0
    }
  end

  def identifier
    "widget_#{id}".to_sym
  end

  def processed_chart_url(user)
    options = { 'user_id' => user.id }
    Liquid::Template.parse(chart_url).render(options)
  end
end
