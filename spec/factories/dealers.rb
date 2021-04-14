# frozen_string_literal: true

FactoryBot.define do
  factory :dealer do
    company { Faker::Name.name }
    legal_name { Faker::Name.name }
    mailing_address { Faker::Name.name }
    city { Faker::Name.name }
    province { Faker::Address.state }
    postal_code { Faker::Name.name }
    phone { Faker::Name.name }
    toll_free { Faker::Name.name }
    fax_number { Faker::Name.name }
    email { Faker::Name.name }
    location_address { Faker::Name.name }
    location_city { Faker::Name.name }
    location_province { Faker::Name.name }
    location_postal_code { Faker::Name.name }
    website { Faker::Name.name }
    date_joined { 3.years.ago }
    shareholder { false }
    director { false }
    atlas_account { Faker::Name.name }
    dometic_account { 1 }
    wells_fargo_account { 1 }
    keystone_account { 'abc123' }
    td_sort_order { Faker::Name.name }
    sal_account { Faker::Name.name }
    mega_group_account { 1 }
    boss_account { 1 }
    dms_system { Faker::Name.name }
    crm_system { Faker::Name.name }
    employee_benefits_provider { Faker::Name.name }
    customs_broker { Faker::Name.name }
    rv_transport { Faker::Name.name }
    digital_marketing { Faker::Name.name }
    rv_brands { 'MyText' }
    status { Faker::Name.name }
  end
end
