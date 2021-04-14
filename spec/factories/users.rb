# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              { Faker::Internet.password(8) }

    trait :admin do
      after(:build) do |user|
        user.add_role :admin
      end
    end
  end
end
