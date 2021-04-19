# frozen_string_literal: true

class PartnerReport < ApplicationRecord
  serialize :parameters, JsonbSerializer

  def self.policy_class
    PartnerReportPolicy
  end

  belongs_to :partner
  has_many :entries, dependent: :destroy
  has_many :units, class_name: 'Units'
  has_many :sales, class_name: 'Sales'
  has_many :dealers, through: :entries
  has_many :results, dependent: :destroy

  validates :type, uniqueness: { scope: %i[partner_id year] }

  delegate :name, to: :partner, prefix: true, allow_nil: true

  before_validation :set_default_parameters

  class << self
    def cache_all!
      PartnerReport.all.find_each(&:cache_results!)
    end
  end

  def calculate_total_units(reported_on: :all, dealer: :all)
    select_units(reported_on: reported_on, dealer: dealer).sum(&:value)
  end

  def calculate_total_sales(reported_on: :all, dealer: :all)
    select_sales(reported_on: reported_on, dealer: dealer).sum(&:value)
  end

  def calculate_total_return_amount(**args)
    calculate_return_amount(scoped_units: select_units(args),
                            scoped_sales: select_sales(args)).round
  end

  def calculate_total_dealer_share(**args)
    calculate_dealer_share(total_amount: calculate_total_return_amount(args),
                           scoped_units: select_units(args),
                           scoped_sales: select_sales(args)).round
  end

  def calculate_total_rvcare_share(**args)
    calculate_total_return_amount(args) - calculate_total_dealer_share(args)
  end

  def cache_results!
    results.delete_all
    dealers.each do |dealer|
      results.create!(dealer: dealer,
                      sales: select_sales(dealer: dealer).sum(:value),
                      units: select_units(dealer: dealer).sum(:value),
                      amount: calculate_total_dealer_share(dealer: dealer))
    end

    self.total_units = calculate_total_units
    self.total_sales = calculate_total_sales
    self.total_return_amount = calculate_total_return_amount
    self.total_rvcare_share = calculate_total_rvcare_share
    self.total_dealer_share = calculate_total_dealer_share
    save!
  end

  def default_parameters
    {}
  end

  def importer(_file)
    raise "The #importer method must be implemented in #{self.class} class"
  end

  private

  def calculate_return_amount(*)
    0
  end

  def dealer_share_multiplier
    0.6
  end

  def calculate_dealer_share(total_amount:, **)
    total_amount * dealer_share_multiplier
  end

  def set_default_parameters
    self.parameters = default_parameters.to_json if parameters.blank? || parameters == '{}'
  end

  def select_units(**args)
    units.where(select_entry_options(**args))
  end

  def select_sales(**args)
    sales.where(select_entry_options(**args))
  end

  def select_entry_options(reported_on: :all, dealer: :all)
    {}.tap do |options|
      options[:reported_on] = reported_on unless reported_on == :all
      options[:dealer] = dealer unless dealer == :all
    end
  end
end
