# frozen_string_literal: true

FactoryBot.define do
  factory :widget do
    sequence(:name) { |n| "widget_#{n}" }
    icon { 'fa-pie-chart' }
  end
end
