# frozen_string_literal: true

class Result < ApplicationRecord
  belongs_to :dealer
  belongs_to :partner_report
end
