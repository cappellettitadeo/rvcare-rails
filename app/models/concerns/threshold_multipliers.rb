# frozen_string_literal: true

module ThresholdMultipliers
  extend ActiveSupport::Concern

  def multiplier(amount:)
    thresholds.each_with_index do |threshold, index|
      next if amount > threshold

      return multipliers[index]
    end

    multipliers.last
  end

  def thresholds
    @thresholds ||= parameter_values_for(prefix: 'threshold')
  end

  def multipliers
    @multipliers ||= parameter_values_for(prefix: 'multiplier')
  end

  def parameter_values_for(prefix:)
    value_count = parameters.keys.select { |k| k =~ /^#{prefix}_*/ }.count
    (1..value_count).map { |n| parameters["#{prefix}_#{n.humanize}"] }
  end
end
