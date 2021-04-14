# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entry, type: :model do
  subject { create(:units) }

  it { is_expected.to(belong_to(:partner_report)) }
  it { is_expected.to(belong_to(:dealer)) }
  it { is_expected.to(validate_uniqueness_of(:reported_on).scoped_to(:dealer_id, :partner_report_id, :type)) }
end
