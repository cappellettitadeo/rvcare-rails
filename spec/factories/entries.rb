# frozen_string_literal: true

FactoryBot.define do
  factory :units, class: 'Units' do
    association(:partner_report)
    association(:dealer)
    reported_on { Time.zone.today - 1.month }
    value { 1 }
  end

  factory :sales, class: 'Sales' do
    association(:partner_report)
    association(:dealer)
    reported_on { Time.zone.today - 1.month }
    value { 10 }
  end
end
