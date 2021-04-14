# frozen_string_literal: true

module ContractValueParameter
  extend ActiveSupport::Concern

  def contract_value
    @contract_value ||= parameters['contract_value']
  end
end
