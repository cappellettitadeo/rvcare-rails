# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Result, type: :model do
  it { is_expected.to belong_to(:dealer) }
  it { is_expected.to belong_to(:partner_report) }
end
