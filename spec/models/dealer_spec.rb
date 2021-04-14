# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dealer, type: :model do
  it { is_expected.to have_many(:staffs) }
end
