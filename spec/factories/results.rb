# frozen_string_literal: true

FactoryBot.define do
  factory :result do
    association(:dealer)
    association(:partner_report)
    amount { 1 }
    reported_on { Date.today }
  end
end
