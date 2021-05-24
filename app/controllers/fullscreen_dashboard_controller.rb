# frozen_string_literal: true

class FullscreenDashboardController < ApplicationController
  before_action :set_fullscreen_widgets, only: %i[show]

  def show
    @dashboard_url = dashboard_url
  end

  private

  def dashboard_url
    return params[:url] if params[:url].present?

    @fullscreen_widgets&.first&.chart_url
  end

  def set_fullscreen_widgets
    return if current_user.nil?

    global_widgets = Widget.where(fullscreen: true, global: true)
    user_widgets = current_user.widgets.where(fullscreen: true)

    if categories.present?
      global_widgets = global_widgets.tagged_with(categories)
      user_widgets = user_widgets.tagged_with(categories)
    end

    @fullscreen_widgets = (global_widgets + user_widgets).uniq
  end

  def categories
    params[:categories]&.split(',') || 'dashboard'
  end
end
