# frozen_string_literal: true

FactoryBot.define do
  factory :partner do
    name { Faker::Company.name }
  end
end
