# frozen_string_literal: true

class Staff < ApplicationRecord
  belongs_to :dealer

  def name
    "#{first_name} #{last_name}"
  end
end
