# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Result, type: :model do
  subject(:result) { create(:result) }

  it { is_expected.to belong_to(:dealer) }
  it { is_expected.to belong_to(:partner_report) }
  it { is_expected.to validate_presence_of(:reported_on) }
  it { is_expected.to validate_uniqueness_of(:reported_on).scoped_to(:partner_report_id, :dealer_id) }
end
