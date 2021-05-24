# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email    { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }

    trait :admin do
      after(:build) do |user|
        user.add_role :admin
      end
    end

    trait :with_fullscreen_dashboard_widget do
      after(:build) do |user|
        user.widgets << create(:widget, :fullscreen, category_list: ['dashboard'])
      end
    end
  end
end
