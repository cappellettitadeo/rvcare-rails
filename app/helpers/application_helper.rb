# frozen_string_literal: true

module ApplicationHelper
  def app_version
    "#{Date.today.strftime('%Y%m%d')}-#{File.read(Rails.root.join('VERSION'))}"
  end
end
