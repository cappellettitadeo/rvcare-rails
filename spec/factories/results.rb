# frozen_string_literal: true

FactoryBot.define do
  factory :result do
    dealer { nil }
    partner_report { nil }
    amount { 1 }
  end
end
