# frozen_string_literal: true

require 'rails_helper'
require 'ammeter/init'

require 'generators/report/report_generator'

RSpec.describe ReportGenerator, type: :generator do
  destination File.expand_path('../../tmp', __dir__)
  arguments %w[MyPartner value:integer]

  before do
    prepare_destination
    run_generator
  end

  describe 'report' do
    subject { file('app/models/my_partner_report.rb') }

    it { is_expected.to exist }
  end

  describe 'spec' do
    subject { file('spec/models/my_partner_report_spec.rb') }

    it { is_expected.to exist }
  end

  describe 'json schema' do
    subject { file('config/schemas/my_partner_parameters.json_schema') }

    it { is_expected.to exist }
  end
end
