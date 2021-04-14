# frozen_string_literal: true

module DealerShareMultiplierParameter
  extend ActiveSupport::Concern

  def dealer_share_multiplier
    @dealer_share_multiplier ||= parameters['dealer_share_multiplier']
  end
end
