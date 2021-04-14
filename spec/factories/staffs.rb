# frozen_string_literal: true

FactoryBot.define do
  factory :staff do
    association(:dealer)
    first_name { 'MyString' }
    last_name { 'MyString' }
    position { 'MyString' }
    email { 'MyString' }
    access_id { 1 }
  end
end
