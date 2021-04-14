# frozen_string_literal: true

class WidgetsController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    @widget = Widget.find(params[:id])

    respond_to do |format|
      format.json { widget_json(@widget) }
    end
  end

  private

  def widget_json(widget)
    render json: widget_data_for_current_user(widget)
  end

  def widget_data_for_current_user(widget)
    current_user.widgets.exists?(id: widget.id) ? widget_data(widget) : {}
  end

  def widget_data(widget)
    {}.tap do |result|
      settings = current_user.dashboard_widget_settings(widget.identifier)
      result[:widget_identifier] = widget.identifier
      result[:html] = render_to_string(partial: '/widgets/custom_widget',
                                       locals: { chart_url: widget.processed_chart_url(current_user),
                                                 identifier: widget.identifier,
                                                 name: widget.name,
                                                 gs_x: settings[:x_coordinate],
                                                 gs_y: settings[:y_coordinate],
                                                 gs_width: settings[:width],
                                                 gs_height: settings[:height] }, formats: [:html])
      result[:settings] = settings
    end
  end

  def current_user
    return User.find(session[:dashboard_user_id]).decorate if session[:dashboard_user_id]

    super
  end
end
