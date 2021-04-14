# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!, except: [:report]
  before_action :set_widgets, only: %i[report show]

  def show; end

  def update
    current_user.update_dashboard!(widgets_hash)
  end

  private

  def current_user
    return User.find(params[:user_id]).try(:decorate) if params[:user_id]

    super
  end

  def set_widgets
    @widgets = current_user.widgets
  end

  def widgets_hash
    return {} unless params[:dashboard]

    params[:dashboard].to_unsafe_h
  end
end
