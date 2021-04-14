# frozen_string_literal: true

FactoryBot.define do
  factory :partner_report do
    association(:partner)
    year { 2020 }

    factory :blank_report, class: 'BlankReport'

    factory :td_bank_report, class: 'TdBankReport'

    factory :ntp_report, class: 'NtpReport'

    factory :wells_fargo_report, class: 'WellsFargoReport'

    factory :sal_warranty_report, class: 'SalWarrantyReport'

    factory :sal_creditor_report, class: 'SalCreditorReport'

    factory :sal_other_report, class: 'SalOtherReport'

    factory :sal_report, class: 'SalReport'

    factory :east_penn_report, class: 'EastPennReport'

    factory :simple_sales_report, class: 'SimpleSalesReport'

    factory :simple_units_report, class: 'SimpleUnitsReport'

    trait :with_td_unit_entries do
      after(:create) do |report|
        extra = {
          'market_share_reached' => true,
          'first_look' => true
        }
        (1..12).each do |month|
          report.entries << create(:units,
                                   value: month * 10,
                                   reported_on: Date.new(report.year, month, 1).end_of_month,
                                   extra: extra)
        end
      end
    end

    trait :with_sal_entries do
      transient do
        monthly_units { nil }
        monthly_value { nil }
      end

      after(:create) do |report, evaluator|
        (1..12).each do |month|
          value = evaluator.monthly_units || month
          units = create(:units, value: value, reported_on: Date.new(report.year, month, 1).end_of_month)

          value = evaluator.monthly_value || 1_000_000 + 100_000 * month
          sales = create(:sales, value: value, reported_on: Date.new(report.year, month, 1).end_of_month, dealer: units.dealer)

          report.entries << units
          report.entries << sales
        end
      end
    end

    trait :with_unit_entries do
      transient do
        monthly_units { nil }
        dealer_count { 1 }
      end

      after(:create) do |report, evaluator|
        evaluator.dealer_count.times do
          dealer = create(:dealer)
          (1..12).each do |month|
            value = evaluator.monthly_units || month
            report.entries << create(:units,
                                     value: value,
                                     reported_on: Date.new(report.year, month, 1).end_of_month,
                                     dealer: dealer)
          end
        end
      end
    end

    trait :with_sales_entries do
      transient do
        monthly_value { nil }
      end

      after(:create) do |report, evaluator|
        (1..12).each do |month|
          value = evaluator.monthly_value || 1_000_000 + 100_000 * month
          report.entries << create(:sales, value: value, reported_on: Date.new(report.year, month, 1).end_of_month)
        end
      end
    end
  end
end
