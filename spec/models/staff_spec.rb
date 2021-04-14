# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Staff, type: :model do
  it { is_expected.to belong_to(:dealer) }
end
