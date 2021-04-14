# frozen_string_literal: true

class Partner < ApplicationRecord
  has_many :partner_reports

  resourcify
end
