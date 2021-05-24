# frozen_string_literal: true

FactoryBot.define do
  factory :widget do
    sequence(:name) { |n| "widget_#{n}" }
    icon { 'fa-pie-chart' }
    chart_url { Faker::Internet.url }

    trait :fullscreen do
      fullscreen { true }
    end

    trait :global do
      global { true }
    end
  end
end
