# frozen_string_literal: true

class Dealer < ApplicationRecord
  resourcify

  has_many :staffs
end
